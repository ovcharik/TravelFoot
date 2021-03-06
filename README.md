# [TravelFoot](http://travel-foot.ru/)

Сервис формирования маршрута для пешей прогулки в городе.

[http://travel-foot.ru/](http://travel-foot.ru/)

## Code Style

Используем двойные пробелы для отступов, везде где только можно, табуляцию вообще не используем, только в редких случаях, где это действительно нужно, например, формирование таблицы при выводе в файл.

Переменые объявляем в формате `camelCase`, класс в формате `CamelCase`.

Названия файлов пишутся с маленькой буквы и слова разделяются андерскором (`_`), если нужно.

## Установка

Зависимости:

  - `nodejs`, version >= 0.10.25
  - `npm`, version >= 1.3.24
  - `mongodb`, version >= 2.4.9

Первый запуск приложения:

    $ git clone git@github.com:ovcharik/TravelFoot.git
    $ cd TravelFoot
    $ npm install
    $ npm start

### Dump and Restore

Dump монги находится в папке `/dump`.

Для востановления данных выполняем в папке с проектом:

    $ mongorestore dump

Для создания дампа:

    $ mongodump --db travel_foot


## Полезные ссылки

* Применяемые концепции
  - [MVC](http://ru.wikipedia.org/wiki/Model-View-Controller) - принцип построения приложения
  - [REST](http://habrahabr.ru/post/38730/) - работа с запросами пользователя
  - [REST API for nodejs](http://habrahabr.ru/post/213931/) - мне эта статья не очень понравилась, но что-то вынести можно

* Backend
  - [Exspress](http://expressjs.com/api.html) - библиотека для работы с запросами пользователя и формирования ответа
  - [Mongoose](http://mongoosejs.com/) - работа с бд
  - [CoffeeScript](http://coffeescript.org/) - диалект js
  - [Jade](http://jade-lang.com/) - темплейты для представлений

* Frontend
  - [Bootstrap](http://getbootstrap.com/) - типовые элементы интерфейса приложения
  - [jQuery](http://jquery.com/) - работа с DOM структурой документа
  - [Backbone](http://backbonejs.org/) - библиотека для построения MVVM
  - [Haml](http://haml.info/) - темплейты
  - [Requirejs](http://requirejs.org/) - библиотека для загрузки скриптов в рантайме


## [Wiki](https://github.com/ovcharik/TravelFoot/wiki)

## [Записка к проекту](https://github.com/ovcharik/TravelFoot/blob/master/course-note.md)

## Разработчики

  - Никульшин Андрей (mmxkz@ya.ru)
  - Лукманова Альфия (sindzirarenai@gmail.com)
  - Овчарик Максим (maksim.ovcharik@gmail.com)
