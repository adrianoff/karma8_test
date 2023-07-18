# karma8 тестовое задание

## Задача
Вы разрабатываете сервис для рассылки уведомлений об истекающих
подписках. За один и за три дня до истечения срока подписки, нужно отправить
письмо пользователю с текстом "{username}, your subscription is expiring
soon".
Имеем следующее
1. Таблица в DB с пользователями (1 000 000+ строк):
   username — имя
   email — емейл
   validts — unix ts до которого действует ежемесячная подписка
   confirmed — 0 или 1 в зависимости от того, подтвердил ли
   пользователь свой емейл по ссылке (пользователю после
   регистрации приходит письмо с уникальной ссылкой на указанный
   емейл, если он нажал на ссылку в емейле в этом поле
   устанавливается 1)
   checked — 0 или 1 (был ли проверен)
   valid — 0 или 1 (является ли валидным)

2. Внешняя функция check_email( $email )
   Проверяет емейл на валидность (на валидный емейл письмо точно
   дойдёт) и возвращает 0 или 1. Функция работает от 1 секунды до 1
   минуты. Вызов функции стоит 1 руб.

3. Функция send_email( $from, $to, $text )
   Отсылает емейл. Функция работает от 1 секунды до 10 секунд.

## Ограничения
1. Необходимо регулярно отправлять емейлы об истечении срока
   подписки на те емейлы, на которые письмо точно дойдёт
2. Можно использовать cron
3. Можно создать необходимые таблицы в DB или изменить
   существующие
4. Для функций check_email и send_email нужно написать "заглушки"
5. По возможности не стоит использовать ООП
6. Код разместить в GitHub
7. Код может быть несовершенным и даже не 100% рабочим — нам
   важно понять образ вашего мышления и подходов к решению
   задачи

## Дополнительные ограничения
1. Не использовать ООП, писать на чистых функциях? 
   **_Да_**

2. Можно ли использовать сервис очередей например Rabbitmq? 
   **_Нет_**

3. Можно ли использовать фреймворки? 
   **_Нет_**

4. Упаковать все в docker контейнеры?
   _**Как удобно тестируемому. В целом необязательно.**_

5. Нужна ли многопоточность?
   **_Главное чтобы задача была выполнена_**

6. Есть ли ограничения по памяти?
   **_memory_limit = 64M_**

# Решение
### Проблемы
1. Главной проблемой и сутью этой задачи является время работы функции _send_email_.
   Предполагаем худший вариант: функция работает 10 секунд для отправки одного письма, 
   писем на отправку может скопиться очень много. Исходя из этого, нам необходима параллельная отправка писем.
2. Вызов функции check_email стоит 1 руб. Необходимо минимизировать ее вызовы или вообще избежать её использования. 
   Её необходимость в данной задаче под большим вопросом. Объяснил ниже. 
3. Таблица в DB с пользователями может быть важной и часто используемой другими частями приложения поэтому желательно 
   ее не блокировать и не сильно нагружать.
4. Необходимо исключить дублирование писем.

### Варианты

Во всех вариантах я предполагаю создание таблицы **mailing_queue** c полями:
**id** <br />
**from_email** - отправитель <br />  
**to_email** - получатель <br />
**subject** - тема <br />
**body** - текст <br />
**is_sent** - 0 не отправлено, 1 отправлено <br />
**send_attempts** - количество попыток отправки. Не пытаться отправить если больше заданного порога. <br />
**hash** - Хэш для уникальности письма чтобы избежать дублирования <br />
**was_opened** - Опциональное поле. 1 - письмо было открыто (Отдельная out of scope функциональность, 
реализуется с помощью webhook-ов) <br />
**sent_at** - время и дата отправки <br />
**created_at** - дата создания записи <br />

Таблица **mailing_queue** будет наполняться отдельно фоновой таской _expire_remind.php_,
а обрабатываться _send_emails.php_ также в фоне (по крону).

Эту таблицу можно использовать и для других типов писем, не только для напоминаний о подписке.


#### Вариант 1. curl_multi_init и curl_multi_exec.

См. папку curl_multi_exec_way

Наилучшее решение на PHP это модификация функции _send_emails_. Она будет принимать массив писем на отправку и, используя
_**curl_multi_init**_ и _**curl_multi_exec**_, запускать параллельную отправку писем. 
Функция будет вызываться из фоновой таски _send_emails.php_ которая будет выбирать N писем на отправку в режиме блокировки 
на чтение: `SELECT * FROM mailing_queue WHERE is_sent=0 LIMIT N FOR UPDATE SKIP LOCKED`
Эта блокировка исключает дублирующую отправку. После отправки проставляем `is_sent=1` в той же транзакции.<br />
В рамках этого варианта (если допускается) можно использовать Guzzle и промисы. <br />

Вместо таблицы **mailing_queue** можно было бы использовать очередь сообщений типа aws sqs или rabbitMQ, но это не подходит
по условиям задачи.

#### Вариант 2. Воркеры и shell_exec

См. папку workers_shell_exec_way

Если модифицировать функцию _send_emails_ нельзя, то будем вызывать её в worker.php, а сами воркеры будем 
запускать из родительской задачи manager.php с помощью функции **shell_exec**. В качестве параметров worker.php принимает $offset и $limit и
будет работать только со своей часть таблицы в режиме блокирующего чтения. Таким образом можно запустить 
N воркеров по K записей и за K*10 секунд обработать N*K писем. Тут важно чтобы воркеры были лёгкими и долго 
в памяти не висели.
В рамках этого варианта добавлена дополнительная таблица validation_queue - очередь имейлов на валидацию.

#### Вариант 3. Golang и горутины

Возможно использовать Go для решения этой задачи. Для параллельных задач в Go существует удобная вещь - горутины
Программа на Go могла бы постоянно висеть в памяти и просматривать таблицу **mailing_queue** и при
появлении нового письма моментально создавать горутину и отправлять его. Тут нужно предусмотреть ограничение 
на количество горутин иначе если скопиться много писем то возможны проблемы с памятью и производительностью.


## Функция check_email
Мне кажется что при отправки письма можно полность отказаться от вызова функции **check_email**.
Проверку email на валидность можно проводить на этапе регистрации пользователя. В условии задачи сказано: 
"_пользователю после регистрации приходит письмо с уникальной ссылкой на указанный емейл, если он нажал на ссылку в емейле в этом поле устанавливается 1_".
На мой взгляд это и есть проверка на валидность, так как письмо дошло, пользователь его открыл и нажал ссылку. Если email провалидировался однажды,
то, скорее всего, навсегда и нет нужды проверять это.<br /><br />
Можно предусмотреть веб хуки от условного Mandrill и признаки в таблице о том что письмо не было доставлено, но это уже out of scope.<br />
Если вызов функции всё же необходим, и изменить внешнюю функцию **check_email** нельзя, то я бы использовал "Вариант 2. Воркеры и shell_exec".
Но функция платная, поэтому лучше придумать другой механизм валидации, например просить пользователя ещё раз подтвердить свой email перейдя по ссылке в письме.


## Выводы
Решение с "Вариант 1. curl_multi_init и curl_multi_exec." получилось масштабируемым и способным быстро обработать большой объём писем за счет параллельной отправки.
При увеличении количества запросов к внешнему почтовому серверу возможно исчерпание лимита на отправку или лимита на количество одновременных соединений. Исправить 
это можно на стороне самого почтового сервера или используя несколько разных почтовых сервисов. Если отправка писем остановится из-за простоя внешнего сервиса,
то при возобновлении его работы очередь разгребётся со временем, есть возможность увеличить количество одновременно обрабатываемых писем.
При значительном росте объёма данных таблицу **mailing_queue** надо периодически чистить, например оставлять в ней только письма текущего года.
При росте количества пользователей в таблице **users** и нагрузки на неё, должны помочь индексы и атомарная обработка по одной строке.
