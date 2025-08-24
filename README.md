# Домашнее задание к занятию "Docker. Часть 2" - `Ключерев Даниил`


### Инструкция по выполнению домашнего задания

   1. Сделайте `fork` данного репозитория к себе в Github и переименуйте его по названию или номеру занятия, например, https://github.com/имя-вашего-репозитория/git-hw или  https://github.com/имя-вашего-репозитория/7-1-ansible-hw).
   2. Выполните клонирование данного репозитория к себе на ПК с помощью команды `git clone`.
   3. Выполните домашнее задание и заполните у себя локально этот файл README.md:
      - впишите вверху название занятия и вашу фамилию и имя
      - в каждом задании добавьте решение в требуемом виде (текст/код/скриншоты/ссылка)
      - для корректного добавления скриншотов воспользуйтесь [инструкцией "Как вставить скриншот в шаблон с решением](https://github.com/netology-code/sys-pattern-homework/blob/main/screen-instruction.md)
      - при оформлении используйте возможности языка разметки md (коротко об этом можно посмотреть в [инструкции  по MarkDown](https://github.com/netology-code/sys-pattern-homework/blob/main/md-instruction.md))
   4. После завершения работы над домашним заданием сделайте коммит (`git commit -m "comment"`) и отправьте его на Github (`git push origin`);
   5. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
   6. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.
   
Желаем успехов в выполнении домашнего задания!
   
### Дополнительные материалы, которые могут быть полезны для выполнения задания

1. [Руководство по оформлению Markdown файлов](https://gist.github.com/Jekins/2bf2d0638163f1294637#Code)

---

### Задание 1

Установите Docker Compose и опишите, для чего он нужен и как может улучшить лично вашу жизнь.  
`Приведите ответ в свободной форме........`

1. Docker Compose был установлен в прошлом ДЗ. 
2. Docker Compose — это инструмент, который позволяет описать и запускать многоконтейнерные приложения с помощью одного файла конфигурации docker-compose.yml. Вместо того чтобы вручную поднимать базы данных, кэши, бекенд, фронтенд и вспомогательные сервисы, всё можно описать один раз и запускать одной командой: docker compose up.  
Он экономит время, ускоряет возможности тестирования новых приложений, делает локальную разработку быстро воспроизводимой если потребуется развернуть ее копию, а эксперименты становятся более безопасными.  

```
danko@dankoubuntu:~$ docker compose version
Docker Compose version v2.35.1
```

---

### Задание 2

Создайте файл docker-compose.yml и внесите туда первичные настройки: 

 * version;
 * services;
 * volumes;
 * networks.

При выполнении задания используйте подсеть 10.5.0.0/16.
Ваша подсеть должна называться: <ваши фамилия и инициалы>-my-netology-hw.
Все приложения из последующих заданий должны находиться в этой конфигурации.  
`Приведите ответ в свободной форме........`

1. Создан файл docker-compose.yml с nginx


```
version: "3.9"

services:
  app:
    image: nginx:stable
    container_name: app-nginx
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - app_data:/usr/share/nginx/html:ro
    networks:
      - klyucherevdo-netology-hw

volumes:
  app_data:

networks:
  klyucherevdo-netology-hw:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.5.0.0/16
          ip_range: 10.5.0.0/24
          gateway: 10.5.0.1

```

---

### Задание 3

1. Создайте конфигурацию docker-compose для Prometheus с именем контейнера <ваши фамилия и инициалы>-netology-prometheus. 
2. Добавьте необходимые тома с данными и конфигурацией (конфигурация лежит в репозитории в директории [6-04/prometheus](https://github.com/netology-code/sdvps-homeworks/tree/main/lecture_demos/6-04/prometheus) ).
3. Обеспечьте внешний доступ к порту 9090 c докер-сервера.  
`Приведите ответ в свободной форме........`
<ol start="1">
<li>Внесены изменения в docker-compose.yml файл</li>
<li>Добавлен файл ./prometheus/prometheus.yml взятый из репозитория в задании</li>
<li>Проверен доступ к поднятому Prometheus с машины windows на которой создана VM</li> 
</ol>

```
version: "3.9"

services:
  prometheus:
    image: prom/prometheus:v2.36.2
    container_name: "klyucherevdo-netology-prometheus"
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/:/etc/prometheus/
      - prometheus_data:/prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
      - --web.console.libraries=/usr/share/prometheus/console_libraries
      - --web.console.templates=/usr/share/prometheus/consoles
    networks:
      - klyucherevdo-netology-hw

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.47.2
    restart: always
    ports:
      - "8081:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - klyucherevdo-netology-hw

volumes:
  prometheus_data:

networks:
  klyucherevdo-netology-hw:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.5.0.0/16
          ip_range: 10.5.0.0/24
          gateway: 10.5.0.1
```

![Доступность с внешнего ip](https://github.com/idanko92/hw-6-04-new/blob/main/img/Screenshot_1.jpg) 

---

### Задание 4

1. Создайте конфигурацию docker-compose для Pushgateway с именем контейнера <ваши фамилия и инициалы>-netology-pushgateway. 
2. Обеспечьте внешний доступ к порту 9091 c докер-сервера.  
`Приведите ответ в свободной форме........`  
<ol start="1">
<li>В прошлый docker-compose.yml добавлена часть кода с pushgateway</li>
<li>Проверен доступ к поднятому Pushgateway с машины Windows, на которой создана VM</li> </ol>


```
  pushgateway:
    image: prom/pushgateway:v1.6.2
    container_name: "klyucherevdo-netology-pushgateway"
    restart: always
    ports:
      - "9091:9091"                                       
    networks:
      - klyucherevdo-netology-hw
```

![Доступность с внешнего ip](https://github.com/idanko92/hw-6-04-new/blob/main/img/Screenshot_2.jpg) 

---

### Задание 5

1. Создайте конфигурацию docker-compose для Grafana с именем контейнера <ваши фамилия и инициалы>-netology-grafana. 
2. Добавьте необходимые тома с данными и конфигурацией (конфигурация лежит в репозитории в директории [6-04/grafana](https://github.com/netology-code/sdvps-homeworks/blob/main/lecture_demos/6-04/grafana/custom.ini).
3. Добавьте переменную окружения с путем до файла с кастомными настройками (должен быть в томе), в самом файле пропишите логин=<ваши фамилия и инициалы> пароль=netology.
4. Обеспечьте внешний доступ к порту 3000 c порта 80 докер-сервера.  
`Приведите ответ в свободной форме........`

<ol start="1">
<li>В прошлый docker-compose.yml добавлена часть кода с Grafana также добавлены grafana_data и grafana_config в volumes</li>
<li>Создан файл  ./grafana/custom/custom.ini с содержимым логином и паролем к Grafana</li> 
<li>Проверен доступ к поднятому Pushgateway с машины Windows, на которой создана VM</li> </ol>

```
  grafana:
    image: grafana/grafana:10.4.3
    container_name: "klyucherevdo-netology-grafana"
    user: "472"
    restart: always
    ports:
      - "80:3000"
    environment:
      GF_PATHS_CONFIG: /etc/grafana/custom/custom.ini
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning/:/etc/grafana/provisioning/
      - ./grafana/custom:/etc/grafana/custom
    networks:
      - klyucherevdo-netology-hw

volumes:
  prometheus_data:
  grafana_data:
  grafana_config:

---

[security]
admin_user = klyucherevdo
admin_password = netology
```

![Доступность с внешнего ip](https://github.com/idanko92/hw-6-04-new/blob/main/img/Screenshot_3.jpg) 

---

### Задание 6

1. Настройте поочередность запуска контейнеров.
2. Настройте режимы перезапуска для контейнеров.
3. Настройте использование контейнерами одной сети.
4. Запустите сценарий в detached режиме.  
`Приведите ответ в свободной форме........`

<ol start="1">
<li>Очередность настроена через depends_on в prometheus и в grafana </li>
<li>restart: always для всех контейнеров. Автоматический перезапуск при сбоях и после рестарта Docker</li> 
<li>все сервисы подключены к одной пользовательской сети klyucherevdo-netology-hw с заданной подсетью 10.5.0.0/16.</li>
<li>Запускаем командой docker compose up -d в режиме detached. Скриншоты тестовых запусков в заданииях выше</li>
</ol>

```
    depends_on: # в prometheus
      - cadvisor
      - pushgateway


    depends_on: # в grafana
      - prometheus
```
---

### Задание 7

1. Выполните запрос в Pushgateway для помещения метрики <ваши фамилия и инициалы> со значением 5 в Prometheus: ```echo "<ваши фамилия и инициалы> 5" | curl --data-binary @- http://localhost:9091/metrics/job/netology```.
2. Залогиньтесь в Grafana с помощью логина и пароля из предыдущего задания.
3. Cоздайте Data Source Prometheus (Home -> Connections -> Data sources -> Add data source -> Prometheus -> указать "Prometheus server URL = http://prometheus:9090" -> Save & Test).
4. Создайте график на основе добавленной в пункте 5 метрики (Build a dashboard -> Add visualization -> Prometheus -> Select metric -> Metric explorer -> <ваши фамилия и инициалы -> Apply.

В качестве решения приложите:

* docker-compose.yml **целиком**;
* скриншот команды docker ps после запуске docker-compose.yml;
* скриншот графика, постоенного на основе вашей метрики.  
`Приведите ответ в свободной форме........`

<ol start="1">
<li>Метрика добавлена и настроена в Grafana</li>
<li>docker-compose.yml в коде ниже</li> 
<li>Скриншот команды docker ps после запуске docker-compose.yml и скриншот графика, постоенного на основе метрики ниже</li>
</ol>

```
version: "3.9"

services:
  prometheus:
    image: prom/prometheus:v2.36.2
    container_name: "klyucherevdo-netology-prometheus"
    restart: always
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/:/etc/prometheus/
      - prometheus_data:/prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
      - --storage.tsdb.path=/prometheus
    depends_on:
      - cadvisor
      - pushgateway
    networks:
      - klyucherevdo-netology-hw

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.47.2
    restart: always
    ports:
      - "8081:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - klyucherevdo-netology-hw

  pushgateway:
    image: prom/pushgateway:v1.6.2
    container_name: "klyucherevdo-netology-pushgateway"
    restart: always
    ports:
      - "9091:9091"
    networks:
      - klyucherevdo-netology-hw

  grafana:
    image: grafana/grafana:10.4.3
    container_name: "klyucherevdo-netology-grafana"
    user: "472"
    restart: always
    depends_on:
      - prometheus
    ports:
      - "80:3000"
    environment:
      GF_PATHS_CONFIG: /etc/grafana/custom/custom.ini
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/provisioning/:/etc/grafana/provisioning/
      - ./grafana/custom:/etc/grafana/custom
    networks:
      - klyucherevdo-netology-hw

volumes:
  prometheus_data:
  grafana_data:
  grafana_config:

networks:
  klyucherevdo-netology-hw:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.5.0.0/16
          ip_range: 10.5.0.0/24
          gateway: 10.5.0.1
```
![docker ps](https://github.com/idanko92/hw-6-04-new/blob/main/img/Screenshot_5.jpg)   

![Метрика в Grafana](https://github.com/idanko92/hw-6-04-new/blob/main/img/Screenshot_4.jpg) 

---

### Задание 8

1. Остановите и удалите все контейнеры одной командой.

В качестве решения приложите скриншот консоли с проделанными действиями. 
`Приведите ответ в свободной форме........`

<ol start="1">
<li>Выполнил команду docker compose down</li>
</ol>

![docker compose down](https://github.com/idanko92/hw-6-04-new/blob/main/img/Screenshot_5.jpg)   
