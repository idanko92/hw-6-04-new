# Домашнее задание к занятию "`Подъём инфраструктуры в Yandex Cloud`" - `Ключерев Даниил`
---

### Задание 1 

Повторить демонстрацию лекции(развернуть vpc, 2 веб сервера, бастион сервер)

1. Проведены настройки VM согласно инструкции из файла README с заданием.
2. Выполнен запуск VM в Yandex Cloud и тестовый скрипт test.yml.
3. Файл terraformapply.log c ходом установке добавлем в папку [7-03](https://github.com/idanko92/net-hw-klycherev/tree/hw-7-03/7-03).
4. Скриншоты с результатами ниже.

![yandexcloud](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/yandexcloud.jpg)  
![test.yml](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/test.yml.jpg)  
![webaa1](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/weba1.jpg)  
![webaa2](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/weba2.jpg)  
![webb](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/webb.jpg)  

---

### Задание 2 

С помощью ansible подключиться к web-a и web-b , установить на них nginx.(написать нужный ansible playbook)

Провести тестирование и приложить скриншоты развернутых в облаке ВМ, успешно отработавшего ansible playbook. 

1. На VM развернутых в прошлом задании выполним код nginx.yml файл находится в папке [7-03](https://github.com/idanko92/net-hw-klycherev/tree/hw-7-03/7-03)
2. Проверки запущеного nginx проведем с VM bastion через curl
3. Удалим все машины после выполнения задания
4. `Заполните здесь этапы выполнения, если требуется ....`
5. `Заполните здесь этапы выполнения, если требуется ....`
6. 

```
Поле для вставки кода...
....
....
....
....
```

![yandexcloud](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/yandexcloud.jpg)  
![nginx.yml](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/nginx.yml.jpg)  
![curlwebab](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/curlwebab.jpg)  
![terraformdestroy](https://github.com/idanko92/net-hw-klycherev/blob/hw-7-03/img/terraformdestroy.jpg)  
