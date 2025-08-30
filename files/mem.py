import time
from pymemcache.client import base

client = base.Client(('localhost', 11211))

# Добавляем ключи с TTL=5 секунд и один с TTL=10 для контроля
client.set('key1', 'value1', expire=5)
client.set('key2', 'value2', expire=5)
client.set('key3', 'value3', expire=5)
client.set('key4', 'value4', expire=10)
# Проверяем сразу после записи
print('Immediately after setting:')
for key in ['key1', 'key2', 'key3', 'key4']:
    value = client.get(key)
    if value is not None:
        print(value.decode('utf-8'))
    else:
        print(None)

# Ждем 6 секунд
time.sleep(6)

# Проверяем после TTL
print('After 6 seconds:')
for key in ['key1', 'key2', 'key3', 'key4']:
    value = client.get(key)
    if value is not None:
        print(value.decode('utf-8'))
    else:
        print(None)