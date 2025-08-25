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
<li>Созданы 3 YML файла с запуском на другой виртуальной машине находящейся в файле inventory.ini в группе ubuntu</li>
<li>Команда для запуска - ansible-playbook playbook(1-3).yml -i inventory.ini -K</li>
<li>Файлы с заданием в папке <a href="https://github.com/idanko92/net-hw-klycherev/tree/hw-7-01/Ex%201-2">Ex 1-2</a></li>
</ol>

```
---
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


playbook2.yml

- name: Install and launch tuned
  hosts: ubuntu
  become: yes

  tasks:
    - name: Install tuned
      apt:
        name: tuned
        state: present
        update_cache: yes

    - name: Add tuned to autostart and start
      systemd:
        name: tuned
        enabled: yes
        state: started

    - name: Gather service facts
      ansible.builtin.service_facts:

    - name: Check that tuned is running
      ansible.builtin.assert:
        that:
          - ansible_facts.services['tuned.service'].state == 'running'
          - ansible_facts.services['tuned.service'].status == 'enabled' or
            ansible_facts.services['tuned.service'].enabled | default(false)
        fail_msg: "tuned is not running and does not"
        success_msg: "tuned is running and autostarts"

    - name: Show active tuned profile
      command: tuned-adm active
      register: tuned_profile
      changed_when: false

    - name: Show profile
      debug:
         var: tuned_profile.stdout
         
         
playbook3.yml

---
- name: Change motd
  hosts: ubuntu
  become: yes

  vars:
    custom_motd: "This is a custom motd"

  tasks:
    - name: Set new motd
      copy:
        dest: /etc/motd
        content: "{{ custom_motd }}\n"
        owner: root
        group: root
        mode: '0644'

```
Процесс установки playbook1.yml  
![Установка playbook1](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook1.jpg)  
Результат playbook1.yml  
![Установка playbook1](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook1result.jpg)  
Процесс установки playbook2.yml  
![Установка playbook2](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook2.jpg)  
Результат playbook2.yml  
![Установка playbook2](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook2result.jpg)  
Процесс установки playbook3.yml  
![Установка playbook3](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook3.jpg)  
Результат playbook3.yml  
![Установка playbook3](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook3result.jpg)  

---

### Задание 2

**Выполните действия, приложите файлы с модифицированным плейбуком и вывод выполнения.** 

Модифицируйте плейбук из пункта 3, задания 1. В качестве приветствия он должен установить IP-адрес и hostname управляемого хоста, пожелание хорошего дня системному администратору. 

<ol start="1">
<li>Внесены изменения в playbook3.yml файл</li>
<li>Команда для запуска - ansible-playbook playbook3new.yml -i inventory.ini -K</li>
<li>Файлы с заданием в папке <a href="https://github.com/idanko92/net-hw-klycherev/tree/hw-7-01/Ex%201-2">Ex 1-2</a></li>
</ol>


```
playbook3new.yml
---
- name: Update MOTD with host IP and hostname
  hosts: all
  become: yes
  gather_facts: true

  vars:
    motd_template: |
      Host: {{ ansible_facts['hostname'] }}
      IP: {{ ansible_facts.get('default_ipv4', {}).get('address', 'N/A') }}
      Have a great day, sysadmin!

  tasks:
    - name: Set MOTD
      ansible.builtin.copy:
        dest: /etc/motd
        content: "{{ motd_template }}\n"
        owner: root
        group: root
        mode: '0644'

    - name: Show current MOTD
      ansible.builtin.command:
        cmd: cat /etc/motd
      register: motd_out
      changed_when: false

    - name: Print MOTD for verification
      ansible.builtin.debug:
        var: motd_out.stdout

```
Процесс установки playbook3new.yml  
![Установка playbook3](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook3new.jpg) 
Результат playbook3new.yml  
![Установка playbook3](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/playbook3newresult.jpg) 

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
<li>Создаем все требуемые папки в рабочем каталоге командой ansible-galaxy init roles/apacheinfo</li>
<li>Добавляем следующие файлы конфигурации site.yml, roles/apacheinfo/tasks/main.yml, roles/apache_info/handlers/main.yml, roles/apache_info/templates/index.html.j2</li>
<li>Запускаем выполнение - ansible-playbook -i inventory.ini site.yml -K</li>
<li>Файлы с заданием в папке <a href="https://github.com/idanko92/net-hw-klycherev/tree/hw-7-01/apacheinfo">apacheinfo</a></li>
</ol>

```
site.yml
---
- name: Setting up Apache to show host systeminfo
  hosts: ubuntu
  become: yes
  roles:
    - apacheinfo

- name: Cheking site avalibility
  hosts: localhost
  tasks:
    - name: Cheking site avalibility
      uri:
        url: "http://{{ hostvars[item]['ansible_default_ipv4']['address'] }}"
        return_content: yes
      loop: "{{ groups['all'] }}"
      register: site_check

    - name: Show check status
      debug:
        var: site_check
		
roles/apache_info/tasks/main.yml
---
- name: install Apache
  apt:
    name: apache2
    state: present
    update_cache: yes

- name: Start apache2
  service:
    name: apache2
    state: started
    enabled: yes

- name: Install ufw
  apt:
    name: ufw
    state: present
    update_cache: yes

- name: Open port 80 in ufw
  ufw:
    rule: allow
    port: '80'
    proto: tcp

- name: Copy index.html from template
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: root
    group: root
    mode: '0644'
  notify: Restart Apache

roles/apache_info/handlers/main.yml
---
- name: Restart Apache
  service:
    name: apache2
    state: restarted

roles/apache_info/templates/index.html.j2

<!DOCTYPE html>
<html>
<head>
    <title>System info {{ ansible_hostname }}</title>
    <meta charset="utf-8">
</head>
<body>
    <h1>Server: {{ ansible_hostname }}</h1>
    <ul>
        <li><b>CPU:</b> {{ ansible_processor[1] }} ({{ ansible_processor_cores }} cores)</li>
        <li><b>RAM:</b> {{ (ansible_memtotal_mb / 1024) | round(1) }} GB</li>
        <li><b>HDD:</b> {{ ansible_devices.sda.size }}</li>
        <li><b>IP-adress:</b> {{ ansible_default_ipv4.address }}</li>
        <li><b>OS:</b> {{ ansible_distribution }} {{ ansible_distribution_version }}</li>
    </ul>
</body>
</html>

```

![Доступность с внешнего ip](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/site1.yml.jpg) 

![Доступность с внешнего ip](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/site2.yml.jpg) 

![Доступность с внешнего ip](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-01/img/index.html.jpg) 

---
