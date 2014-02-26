1. TravelFoot
2. Состав:
  - Никульшин Андрей
  - Лукманова Альфия
  - Овчарик Максим
3. Описание сервиса: cервис для поиска оптимального маршрута по основным достопримечательностям города.
  
  3.1. Зачем он нужен: 
    Помощь туристам в подборе достопримечательностей. В том случае, если у них мало времени и они хотят быстро посетить основные достопримечательности (музеи, памятники и т.д.). Во 2-ом варианте пользователю могут быть предложены места для посещения, в зависимости от их рейтинга (по отзывам, оценкам других туристов), что сократит поиск наиболее интересных точек. 
    На своем опыте: когда я ездила в Казань, мне пришлось прочесывать кучу сайтов для поиска интересных мест, читать отзывы пользователей. Затем продумывать маршрут на каждый день пребывания в городе. Случалось, что я ошибалась и выбирала для посещения место, которое в этот день не работало или же приходилось очень много времени тратить на перемещения между достопримечательностями. [Лукманова А.Р.]
Вариант учета времени работы музеев/выставок/парков тоже рассматривается, но это в том случае, если будем успевать. [а может будет несложно, и точно сделаем]

  3.2. Как он будет работать:
    Выбираем начальную точку, конечную точку маршрута. Получаем список достопримечательностей в задаваемом радиусе от маршрута. Либо маршрут между двумя точками через достопримечательности.
    Относительно текущего местоположения формируем маршрут по достопримечательностям, учитывая пожелания пользователя и, возможно, рейтинг достопримечательностей.
    (Функционал вариантов может смешиваться, показаны для примера)
    Планируется[предварительно]: использование 2gis, реализация в виде веб-приложения, сервер на node.js, СУБД - mongo.db, связь между сервером и клиентом с помощью socket.io.

4. Распределение ролей и задач (если задачи определены).
  - Разработчик БД - Никульшин Андрей
  - Разработчик пространственных запросов - Лукманова Альфия
  - Разработчик интерфейса - Овчарик Максим

Лукманова Альфия также будет оказывать помощь в работе менеджера. В частности, “по пинаниям” и некоторым моментам организации.