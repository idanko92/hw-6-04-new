# Домашнее задание к занятию "Ansible.Часть 2" - `Ключерев Даниил`


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

**Выполните действия, приложите файлы с плейбуками и вывод выполнения.**

Напишите три плейбука. При написании рекомендуем использовать текстовый редактор с подсветкой синтаксиса YAML.

Плейбуки должны: 

1. Скачать какой-либо архив, создать папку для распаковки и распаковать скаченный архив. Например, можете использовать [официальный сайт](https://kafka.apache.org/downloads) и зеркало Apache Kafka. При этом можно скачать как исходный код, так и бинарные файлы, запакованные в архив — в нашем задании не принципиально.
2. Установить пакет tuned из стандартного репозитория вашей ОС. Запустить его, как демон — конфигурационный файл systemd появится автоматически при установке. Добавить tuned в автозагрузку.
3. Изменить приветствие системы (motd) при входе на любое другое. Пожалуйста, в этом задании используйте переменную для задания приветствия. Переменную можно задавать любым удобным способом.


<ol start="1">
<li>Внесены изменения в docker-compose.yml файл</li>
<li>Добавлен файл ./prometheus/prometheus.yml взятый из репозитория в задании</li>
<li>Проверен доступ к поднятому Prometheus с машины windows на которой создана VM</li> 
</ol>

```
playbook1.yml
---
- name: Dl and extract Apache Kafka
  hosts: ubuntu
  become: yes

  vars:
    download_url: "https://dlcdn.apache.org/kafka/4.0.0/kafka-4.0.0-src.tgz"
    download_path: "/tmp/kafka.tgz"
    extract_dir: "/opt/kafka"

  tasks:
    - name: Check that extract folder exists
      file:
        path: "{{ extract_dir }}"
        state: directory
        owner: root
        group: root
        mode: '0755'

    - name: Dl Kafka archive
      get_url:
        url: "{{ download_url }}"
        dest: "{{ download_path }}"
        mode: '0644'

    - name: Extract to dir
      unarchive:
        src: "{{ download_path }}"
        dest: "{{ extract_dir }}"
        remote_src: yes

```

---

### Задание 2

**Выполните действия, приложите файлы с модифицированным плейбуком и вывод выполнения.** 

Модифицируйте плейбук из пункта 3, задания 1. В качестве приветствия он должен установить IP-адрес и hostname управляемого хоста, пожелание хорошего дня системному администратору. 

<ol start="1">
<li>Внесены изменения в docker-compose.yml файл</li>
<li>Добавлен файл ./prometheus/prometheus.yml взятый из репозитория в задании</li>
<li>Проверен доступ к поднятому Prometheus с машины windows на которой создана VM</li> 
</ol>


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

**Выполните действия, приложите архив с ролью и вывод выполнения.**

Ознакомьтесь со статьёй [«Ansible - это вам не bash»](https://habr.com/ru/post/494738/), сделайте соответствующие выводы и не используйте модули **shell** или **command** при выполнении задания.

Создайте плейбук, который будет включать в себя одну, созданную вами роль. Роль должна:

1. Установить веб-сервер Apache на управляемые хосты.
2. Сконфигурировать файл index.html c выводом характеристик каждого компьютера как веб-страницу по умолчанию для Apache. Необходимо включить CPU, RAM, величину первого HDD, IP-адрес.
Используйте [Ansible facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html) и [jinja2-template](https://linuxways.net/centos/how-to-use-the-jinja2-template-in-ansible/). Необходимо реализовать handler: перезапуск Apache только в случае изменения файла конфигурации Apache.
4. Открыть порт 80, если необходимо, запустить сервер и добавить его в автозагрузку.
5. Сделать проверку доступности веб-сайта (ответ 200, модуль uri).

В качестве решения:
- предоставьте плейбук, использующий роль;
- разместите архив созданной роли у себя на Google диске и приложите ссылку на роль в своём решении;
- предоставьте скриншоты выполнения плейбука;
- предоставьте скриншот браузера, отображающего сконфигурированный index.html в качестве сайта.

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

