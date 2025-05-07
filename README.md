# Notes

## О проекте

Приложение для создания заметок, работающее на iOS, Android, MacOS, Windows. Реализована тёмная тема, поиск заметок и сортировка по дате создания.

<img src="https://raw.githubusercontent.com/andrei-uni/notes/refs/heads/master/screenshots/1.png" width="230">
<img src="https://raw.githubusercontent.com/andrei-uni/notes/refs/heads/master/screenshots/2.png" width="230">
<img src="https://raw.githubusercontent.com/andrei-uni/notes/refs/heads/master/screenshots/3.png" width="230">
<img src="https://raw.githubusercontent.com/andrei-uni/notes/refs/heads/master/screenshots/4.png" width="230">
<img src="https://raw.githubusercontent.com/andrei-uni/notes/refs/heads/master/screenshots/5.png" width="230">
<img src="https://raw.githubusercontent.com/andrei-uni/notes/refs/heads/master/screenshots/6.png" width="230">

## Запуск

- Установите [fvm](https://fvm.app/)

- Склонируйте репозиторий и введите команду ```fvm use```. Будет использована версия flutter, указанная в файле ```.fvmrc```.

- Получите зависимости ```fvm flutter pub get```.

- Сгенерируйте файлы ```fvm dart run build_runner build -d```

- Запустите ```fvm flutter run```.

## Архитектура

В проекте используется feature-first подход. В каждой подпапке папки ```features``` должна располагаться фича — как модуль: UI + логика + данные (здесь у отдельных фич нет своих данных, так как проект слишком мал). В папке ```core``` находятся сервисы и репозитории, которые могут быть использованы по всему приложению.

В проекте для передачи зависимостей используется концепция ```scope```.

В качестве локального хранилища данных используется ```drift``` - обертка над ```sqlite```.

Вся бизнес логика приложения инкапсулирована в ```bloc```'и, которые в свою очередь вызывают методы репозиториев. Репозитории скрывают детали того, откуда приходят данные и пребразовывают бизнес-модели в сырые данные и передают их в сервисы, которые уже напрямую работают с внешними источниками данных.
