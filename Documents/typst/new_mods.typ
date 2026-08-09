#set document(title: "Minecraft Mods Catalog")
#set page(
  paper: "a4",
  margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm)
)
#set text(font: "DejaVu Sans", size: 11pt, lang: "ru")

#let mod(id, name, version, description, dependencies: "") = {
  box(
    width: 100%,
    inset: 10pt,
    stroke: (bottom: 1pt + rgb("#cccccc")),
    [
      *#id. #name* `v#version`
      
      [#description]
      
      #if dependencies != "" [
        🔗 *Зависимости:* #dependencies
      ]
    ]
  )
}

= Каталог Minecraft Модов
_Версия: 1.20.1 (Forge/Fabric)_

#h(1em)

== 📚 Библиотеки и Зависимости

#mod("LIB-001", "Cloth Config", "11.1.136", 
  "Конфигурационная библиотека для модов. Необходима для работы модов с настройками интерфейса.")

#mod("LIB-002", "Yet Another Config Lib v3", "3.6.6",
  "Расширенная библиотека конфигурации. Позволяет модам создавать гибкие меню настроек.")

#mod("LIB-003", "Architectury", "9.2.14",
  "Библиотека совместимости между Forge и Fabric. Позволяет модам работать на обеих платформах.")

#mod("LIB-004", "Kotlin for Forge", "4.12.0",
  "Поддержка языка Kotlin для Forge модов.")

#mod("LIB-005", "Bookshelf", "20.2.15",
  "Вспомогательная библиотека с утилитами для разработчиков модов.",
  dependencies: "Forge API")

#mod("LIB-006", "Placebo", "8.6.3",
  "Утилита-библиотека с общими функциями для модов.",
  dependencies: "Forge API")

#mod("LIB-007", "OWO Lib", "0.11.2",
  "Универсальная библиотека с инструментами для UI и конфигурации.",
  dependencies: "Architectury")

#mod("LIB-008", "Coroutil", "1.3.7",
  "Библиотека утилит для разработки модов Forge.")

#mod("LIB-009", "Majrusz Library", "7.0.8",
  "Поддержка для модов серии Majrusz. Содержит общие функции.",
  dependencies: "Forge API")

#mod("LIB-010", "Caelus", "3.2.0",
  "Библиотека для механики полета. Требуется для модов с полётом.",
  dependencies: "Forge API")

#mod("LIB-011", "Collective", "8.29",
  "Объединённая библиотека с полезными классами для модов.")

#mod("LIB-012", "Iceberg", "1.1.25",
  "Утилита для расширения базовых функций Minecraft.")

#mod("LIB-013", "Cristellib", "1.1.5",
  "Универсальная библиотека для модов.",
  dependencies: "Forge API")

#mod("LIB-014", "Kaleido Config", "0.3.1",
  "Система конфигурации для модов.")

#h(1em)

== 🎨 Графика и Визуальные Эффекты

#mod("VIS-001", "Embeddium", "0.3.31",
  "Улучшенная версия Sodium для Forge. Оптимизирует рендеринг графики и увеличивает FPS.",
  dependencies: "Kotlin for Forge")

#mod("VIS-002", "Sodium Extras", "1.0.7",
  "Расширение для Sodium. Добавляет дополнительные графические опции.",
  dependencies: "Embeddium")

#mod("VIS-003", "Sodium Dynamic Lights", "1.0.10",
  "Динамическое освещение от предметов и сущностей.",
  dependencies: "Embeddium, Sodium Options API")

#mod("VIS-004", "Sodium Options API", "1.0.10",
  "API для управления опциями Sodium из других модов.")

#mod("VIS-005", "Entity Model Features", "3.2.4",
  "Позволяет использовать кастомные модели для моб-сущностей.",
  dependencies: "GeckoLib")

#mod("VIS-006", "Entity Texture Features", "7.1",
  "Поддержка кастомных текстур для сущностей.",
  dependencies: "GeckoLib")

#mod("VIS-007", "GeckoLib", "4.8.3",
  "Мощная библиотека для анимированных моделей и текстур.",
  dependencies: "Forge API")

#mod("VIS-008", "BetterF3", "7.0.2",
  "Улучшенное меню отладки F3 с полезной информацией о мире и производительности.",
  dependencies: "Cloth Config")

#mod("VIS-009", "Async Particles", "0.2b.3",
  "Асинхронная обработка частиц для улучшения производительности.")

#mod("VIS-010", "Chunks Fade In", "3.0.22",
  "Плавное появление чанков при загрузке вместо резкого 'поп-эффекта'.")

#mod("VIS-011", "Immediately Fast", "1.5.4",
  "Оптимизация загрузки экранов и интерфейсов в Minecraft.",
  dependencies: "Fabric API (или Forge)")

#mod("VIS-012", "Radium", "0.12.4",
  "Оптимизация рендеринга светофильтров. Улучшает производительность.")

#mod("VIS-013", "Highlight", "1.1.9",
  "Подсвечивание предметов в инвентаре и сундуках.",
  dependencies: "Cloth Config")

#mod("VIS-014", "Particular", "1.5.4",
  "Улучшенные визуальные эффекты частиц.",
  dependencies: "Forge API")

#mod("VIS-015", "Inventory Particles", "2.4.0",
  "Эффекты частиц при взаимодействии с инвентарём.")

#mod("VIS-016", "Item Physics", "1.8.13",
  "Физика для выпадающих предметов - более реалистичное падение и скатывание.",
  dependencies: "Forge API")

#h(1em)

== 👁️ UI и Информация

#mod("UI-001", "Just Enough Items (JEI)", "15.20.0",
  "Необходимый мод для просмотра рецептов всех предметов в игре. Основной инструмент для новичков.",
  dependencies: "Forge API")

#mod("UI-002", "Roughly Enough Items (REI)", "12.1.785",
  "Альтернатива JEI для Fabric. Функционал очень похож.",
  dependencies: "Architectury, Cloth Config")

#mod("UI-003", "EMI", "1.1.24",
  "Ещё одна альтернатива JEI с улучшенным интерфейсом и производительностью.",
  dependencies: "Forge API")

#mod("UI-004", "Jade", "11.13.2",
  "Выводит информацию о блоках и сущностях при наведении курсора.",
  dependencies: "Cloth Config")

#mod("UI-005", "Waila", "1.3.5",
  "Классический мод для вывода информации о блоках (предшественник Jade).",
  dependencies: "Cloth Config")

#mod("UI-006", "Apple Skin", "2.5.1",
  "Улучшенное отображение голода и насыщения на интерфейсе.")

#mod("UI-007", "Inventory Profiles Next", "1.10.20",
  "Автоматическое сортирование инвентаря и управление вещами.",
  dependencies: "Cloth Config, libIPN")

#mod("UI-008", "Mouse Tweaks", "2.25.1",
  "Улучшения для работы с мышью в инвентаре - быстрое перемещение предметов.",
  dependencies: "Forge API")

#mod("UI-009", "Item Borders", "1.2.2",
  "Красивые границы вокруг иконок предметов.",
  dependencies: "Cloth Config")

#mod("UI-010", "Smooth GUI", "1.1.1",
  "Плавные анимации интерфейсов и меню.",
  dependencies: "Forge API")

#mod("UI-011", "Click Through Plus", "3.5.1",
  "Позволяет кликать через прозрачные блоки и слои интерфейса.",
  dependencies: "Cloth Config")

#mod("UI-012", "Right Click Harvest", "4.6.1",
  "Праворуч сбор урожая и разрушение блоков.",
  dependencies: "Cloth Config")

#mod("UI-013", "Enchantment Descriptions", "17.1.21",
  "Выводит описания зачарований при наведении на них.",
  dependencies: "Cloth Config")

#mod("UI-014", "Legendary Tooltips", "1.4.5",
  "Красивые всплывающие подсказки для предметов.",
  dependencies: "Cloth Config, Placebo")

#mod("UI-015", "Damage Numbers", "1.4.0",
  "Отображение урона над головами мобов и игроков.",
  dependencies: "Forge API")

#mod("UI-016", "Advancement Plaques", "1.6.9",
  "Улучшенное отображение достижений с красивыми рамками.",
  dependencies: "Cloth Config")

#mod("UI-017", "Status Effect Bars", "1.0.3",
  "Отображение полосок эффектов статуса более наглядно.",
  dependencies: "Cloth Config")

#mod("UI-018", "Simply Tooltips", "0.1.3",
  "Упрощённые и улучшенные подсказки для предметов.")

#h(1em)

== 🔧 Утилиты и Качество Жизни

#mod("UTIL-001", "Dynamic FPS", "3.11.4",
  "Автоматическое снижение FPS когда игра в фоне - экономит ресурсы.",
  dependencies: "Forge API")

#mod("UTIL-002", "Presence Footsteps", "1.0.0",
  "Звуки шагов в зависимости от типа блока под ногами. Более реалистичный звук.",
  dependencies: "Forge API")

#mod("UTIL-003", "Sound Physics Remastered", "1.4.10",
  "Реалистичная физика звука - отражение, поглощение, эхо.",
  dependencies: "Forge API")

#mod("UTIL-004", "Tool Stats", "16.0.10",
  "Отображение статистики инструментов при наведении.",
  dependencies: "Cloth Config")

#mod("UTIL-005", "Smooth Swapping", "0.9.3.2",
  "Плавная смена предметов между слотами инвентаря.",
  dependencies: "Forge API")

#mod("UTIL-006", "BetterThirdPerson", "1.9.0",
  "Улучшения режима от третьего лица - лучшая камера и позиция.",
  dependencies: "GeckoLib")

#mod("UTIL-007", "Boat Item View", "0.0.5",
  "Отображение предметов в рукав игрока при езде в лодке.")

#mod("UTIL-008", "Punchy", "2.5.6",
  "Улучшенная боевая система с более отзывчивыми ударами.")

#mod("UTIL-009", "Survey Map", "1.2.4",
  "Мод для создания карт. Интеграция с Antique Atlas.",
  dependencies: "OWO Lib")

#mod("UTIL-010", "WI-Zoom", "1.5",
  "Увеличение/зум камеры колесом мыши - удобно для дальних просмотров.",
  dependencies: "Forge API")

#mod("UTIL-011", "Visibility Toggle", "3",
  "Скрытие чужих плащей и предметов для избежания лага в многопользовательском режиме.")

#mod("UTIL-012", "Entity Culling", "1.10.3",
  "Оптимизация рендеринга не видимых сущностей - прирост FPS.",
  dependencies: "Forge API")

#mod("UTIL-013", "Chunky", "1.3.146",
  "Инструмент для предварительной загрузки чанков вокруг спавна.",
  dependencies: "Fabric API или Forge")

#h(1em)

== ⚔️ Геймплей и Механика

#mod("GAME-001", "Create", "6.0.8",
  "Мод о механике и машинах. Позволяет создавать автоматизированные системы из гайков и шестеренок.",
  dependencies: "Create Connected, Cloth Config, Creativecore")

#mod("GAME-002", "Create Connected", "1.1.13",
  "Дополнение для Create - соединение объектов на расстояния.",
  dependencies: "Create, Cloth Config")

#mod("GAME-003", "Create Addition", "1.3.3",
  "Добавляет генератор дизеля для Create мода.",
  dependencies: "Create, Creativecore")

#mod("GAME-004", "Create Big Cannons", "5.11.4",
  "Пушки и артиллерия для Create мода - огромные стреляющие конструкции.",
  dependencies: "Create, Ritchies Projectile Lib, Creativecore")

#mod("GAME-005", "Create Diesel Generators", "1.3.11",
  "Дизельные генераторы для Create мода.",
  dependencies: "Create, Cloth Config")

#mod("GAME-006", "Botania", "450",
  "Магический мод с флорой и волшебством. Большой контент для магических игроков.",
  dependencies: "Patchouli, GeckoLib")

#mod("GAME-007", "Ars Nouveau", "4.12.7",
  "Продвинутая магическая система с ведьмовством. Создавайте заклинания.",
  dependencies: "Patchouli, Architectury, GeckoLib")

#mod("GAME-008", "Ars Elemental", "0.6.7.9",
  "Расширение для Ars Nouveau - дополнительные стихии и заклинания.",
  dependencies: "Ars Nouveau")

#mod("GAME-009", "Apotheosis", "7.4.8",
  "Улучшение зачарований и добавление новых редких предметов.",
  dependencies: "Placebo, Cloth Config")

#mod("GAME-010", "Patchouli", "85",
  "Книга рецептов и гайдов для других модов. Обязательна для многих магических модов.",
  dependencies: "Architectury")

#mod("GAME-011", "Just Enough Botania", "0.2.1",
  "Интеграция Botania с JEI/EMI для просмотра рецептов.",
  dependencies: "Botania, JEI/EMI")

#mod("GAME-012", "AIOT Botania", "4.0.8",
  "Улучшение инструментов Botania и добавление новых функций.")

#mod("GAME-013", "Farmers Delight", "1.3.2",
  "Кулинария и фермерство - новые культуры, рецепты и еда.",
  dependencies: "Forge API")

#mod("GAME-014", "More Delight", "1.20",
  "Дополнение к Farmers Delight с ещё больше рецептами и едой.")

#mod("GAME-015", "Brew Chew", "5.0",
  "Система зелий и напитков - создавайте напитки с эффектами.",
  dependencies: "Curios")

#mod("GAME-016", "Better Combat", "1.9.0",
  "Улучшенная боевая система с новыми комбо и техниками.",
  dependencies: "GeckoLib, Player Animation Lib")

#mod("GAME-017", "Majrusz's Enchantments", "1.10.8",
  "Добавляет 50+ новых зачарований в игру.",
  dependencies: "Majrusz Library, Cloth Config")

#mod("GAME-018", "Relics", "0.8.0.13",
  "Реликвии - мощные артефакты с особыми эффектами.",
  dependencies: "Curios, Architectury, GeckoLib")

#mod("GAME-019", "Simply Swords", "1.56.0",
  "Добавляет 40+ новых мечей с разными свойствами.",
  dependencies: "Forge API, GeckoLib")

#mod("GAME-020", "Fantasy Armor", "1.2.4",
  "Фэнтезийные доспехи с магическими свойствами.",
  dependencies: "GeckoLib")

#mod("GAME-021", "Fantasy Weapons", "0.4",
  "Фэнтезийное оружие с уникальными способностями.",
  dependencies: "GeckoLib")

#mod("GAME-022", "Curios", "5.14.1",
  "Куриозы (украшения) - дополнительные слоты для предметов (колец, амулетов и т.д.).",
  dependencies: "Architectury, Caelus")

#mod("GAME-023", "Hexalia", "1.3.0",
  "Добавляет гексы и проклятия в игру.")

#mod("GAME-024", "Lootr", "0.7.35.94",
  "Случайные сундуки в структурах с разным содержимым.",
  dependencies: "Forge API")

#mod("GAME-025", "Loot Tables", "",
  "Кастомные таблицы лута для сундуков и мобов.")

#mod("GAME-026", "The Hordes", "1.6.3f",
  "Волны врагов которые нападают ночью с бонусами.",
  dependencies: "GeckoLib")

#mod("GAME-027", "Mob Captains", "3.1.2",
  "Редкие боссы мобов с повышенной сложностью.",
  dependencies: "GeckoLib")

#mod("GAME-028", "Terramity", "0.9.8",
  "Камни и территории - строите территории и защищаете их.",
  dependencies: "Cloth Config")

#mod("GAME-029", "Wither Spawn Animation", "1.6.2",
  "Красивая анимация появления Визера.",
  dependencies: "Forge API")

#h(1em)

== 🌍 Генерация Мира и Структуры

#mod("WORLD-001", "Yungs Better Dungeons", "4.0.4",
  "Подземелья переработаны с новыми залами, сундуками и сложностью.",
  dependencies: "YungsAPI")

#mod("WORLD-002", "Yungs Better Caves", "2.0.5",
  "Пещеры переработаны - больше разнообразия, новые биомы внутри.",
  dependencies: "YungsAPI, Terrablender")

#mod("WORLD-003", "Yungs Better Mineshafts", "4.0.4",
  "Шахты переделаны с новыми структурами и сложностью.",
  dependencies: "YungsAPI")

#mod("WORLD-004", "Yungs Better Strongholds", "4.0.3",
  "Крепости улучшены - больше комнат и лучше генерация.",
  dependencies: "YungsAPI")

#mod("WORLD-005", "Yungs Better Nether Fortresses", "2.0.6",
  "Адские крепости с новым дизайном и сложностью.",
  dependencies: "YungsAPI")

#mod("WORLD-006", "Yungs Better End Island", "2.0.6",
  "Остров Края улучшен с новыми структурами.",
  dependencies: "YungsAPI")

#mod("WORLD-007", "Yungs Better Bridges", "4.0.3",
  "Новые мосты в Нижнем мире.",
  dependencies: "YungsAPI")

#mod("WORLD-008", "Yungs Better Desert Temples", "3.0.3",
  "Пустынные храмы переработаны.",
  dependencies: "YungsAPI")

#mod("WORLD-009", "Yungs Better Jungle Temples", "2.0.5",
  "Джунгльские храмы с новыми залами.",
  dependencies: "YungsAPI")

#mod("WORLD-010", "Yungs Better Ocean Monuments", "3.0.4",
  "Подводные памятники улучшены.",
  dependencies: "YungsAPI")

#mod("WORLD-011", "Yungs Better Witch Huts", "3.0.3",
  "Хижины ведьм в болотах переделаны.",
  dependencies: "YungsAPI")

#mod("WORLD-012", "YungsAPI", "4.0.6",
  "Основная библиотека для всех Yungs модов.",
  dependencies: "Cloth Config")

#mod("WORLD-013", "Yungs Extras", "4.0.3",
  "Дополнительные элементы для модов Yungs.",
  dependencies: "YungsAPI")

#mod("WORLD-014", "TerraBlender", "3.0.1.7",
  "Генератор биомов - позволяет добавлять новые биомы.",
  dependencies: "Terraform API")

#mod("WORLD-015", "Vanilla Refresh", "1.4.19h",
  "Обновление ванильных структур - новые дома в деревнях.",
  dependencies: "Cloth Config")

#mod("WORLD-016", "Antique Atlas", "3.1.2",
  "Красивая карта мира с экспедициями.",
  dependencies: "OWO Lib, Connector")

#mod("WORLD-017", "Towns and Towers", "1.12",
  "Города и башни которые генерируются в мире.",
  dependencies: "Fabric API или Forge")

#mod("WORLD-018", "Gateways to Eternity", "4.2.6",
  "Врата в конец света с новыми структурами.",
  dependencies: "Cloth Config")

#h(1em)

== 🎮 Контент и Предметы

#mod("CONTENT-001", "Min Cells", "2.0.0",
  "Полнофункциональный контент из игры Dead Cells. Оружие, враги, предметы.",
  dependencies: "GeckoLib, Gimm-iq, Cardinal Components")

#mod("CONTENT-002", "Noisium ED", "3.0.5",
  "Красивые ландшафты с шумом Перлина.",
  dependencies: "Fabric API (через Connector)")

#mod("CONTENT-003", "Steam Rails", "1.7.2",
  "Паровые рельсы и локомотивы для железных дорог.",
  dependencies: "Create (опционально), Creativecore")

#mod("CONTENT-004", "Timber Strike", "1.1",
  "Новые типы дерева и инструменты.",
  dependencies: "Forge API")

#mod("CONTENT-005", "Slice and Dice", "3.6.0",
  "Новые способы нарезки предметов - декоративные блоки.",
  dependencies: "Cloth Config")

#mod("CONTENT-006", "Healing Campfire", "6.2",
  "Кострище которое исцеляет над ним стоящих игроков.",
  dependencies: "Cloth Config")

#mod("CONTENT-007", "Watut", "1.2.3",
  "Инструменты и многое другое для Minecraft.",
  dependencies: "Architectury")

#mod("CONTENT-008", "Right Click Harvest", "4.6.1",
  "Сбор урожая правым кликом без инструмента.",
  dependencies: "Cloth Config")

#h(1em)

== 🎬 Анимации и Персонаж

#mod("ANIM-001", "Emotecraft", "2.2.7",
  "Эмоции и выражения лица для персонажа - смейтесь, плачьте и т.д.",
  dependencies: "GeckoLib")

#mod("ANIM-002", "No Enough Animations", "1.12.3",
  "Дополнительные анимации для действий игрока.",
  dependencies: "Forge API")

#mod("ANIM-003", "Skin Layers 3D", "1.11.1",
  "3D слои кожи персонажа - плащи выглядят реалистичнее.",
  dependencies: "GeckoLib")

#mod("ANIM-004", "Player Animation Lib", "1.0.2",
  "Библиотека для анимаций игрока в модах.",
  dependencies: "GeckoLib")

#mod("ANIM-005", "Spawn Animations", "1.11.2",
  "Красивые анимации появления мобов.",
  dependencies: "Forge API")

#h(1em)

== 🌧️ Погода и Атмосфера

#mod("WEATHER-001", "Enhanced Celestials", "5.0.3.2",
  "Улучшенное небо - красивые восходы, закаты и звёзды.",
  dependencies: "GeckoLib, Architectury")

#mod("WEATHER-002", "Weather 2", "2.8.3",
  "Улучшенная система погоды - грозы, торнадо, снежные бури.",
  dependencies: "Cloth Config")

#h(1em)

== 🔊 Звук

#mod("SOUND-001", "Sounds", "2.2.1",
  "Улучшенные звуки окружающей среды и событий.",
  dependencies: "Fabric API (через Connector)")

#h(1em)

== 🎙️ Голос

#mod("VOICE-001", "Voice Chat", "2.6.18",
  "Голосовой чат внутри игры - разговаривайте с игроками на сервере.",
  dependencies: "Opus Audio Codec")

#h(1em)

== 🚀 Производительность

#mod("PERF-001", "Prism", "1.0.5",
  "Улучшение производительности и оптимизация FPS.",
  dependencies: "Cloth Config")

#h(1em)

== 🎪 Развлечение и Развлекательный Контент

#mod("FUN-001", "Explosive Enhancement", "1.1.0",
  "Улучшение взрывов и их эффектов.",
  dependencies: "Forge API")

#h(1em)

== 🔌 Адаптеры и Конвертеры

#mod("ADAPTER-001", "Connector", "1.0.0-beta.48",
  "Адаптер для использования Fabric модов на Forge сервере.",
  dependencies: "Fabric API, Forge API")

#mod("ADAPTER-002", "Connector Extras", "1.11.2",
  "Дополнительные возможности для Connector.",
  dependencies: "Connector, Fabric API")

#mod("ADAPTER-003", "Fabric API", "0.92.6",
  "Основная API для Fabric модов (загружается через Connector).",
  dependencies: "Connector")

#mod("ADAPTER-004", "VMP Fabric", "0.2.0+beta",
  "Оптимизация Fabric для работы на Forge.",
  dependencies: "Connector, Fabric API")

#h(1em)

== 📊 Таблица зависимостей и совместимости

#table(
  columns: (1fr, 1fr, 1fr),
  [*Мод*], [*Основные зависимости*], [*Рекомендуется с*],
  
  [Yungs Better Dungeons], [YungsAPI], [TerraBlender],
  [Create], [Creativecore, Cloth Config], [Create Connected, Create Addition],
  [Botania], [Patchouli, GeckoLib], [AIOT Botania, Just Enough Botania],
  [Ars Nouveau], [Patchouli, GeckoLib], [Ars Elemental],
  [Apotheosis], [Placebo], [Majrusz's Enchantments],
  [JEI], [Forge API], [Jade, EMI],
  
)

#pagebreak()

== ℹ️ Легенда

- *ID*: Уникальный идентификатор мода в каталоге
- *Версия*: Версия мода для MC 1.20.1
- *Зависимости*: Другие моды или библиотеки требуемые для работы
- *Описание*: Краткое описание функционала мода

== 📝 Примечания

1. *Все моды* совместимы с MC 1.20.1 для Forge (если не указано иное)
2. *Библиотеки* обязательны для работы указанных модов
3. *Производительность* оптимальна при использовании модов из раздела "Производительность"
4. *Конфликты*: REI конфликтует с JEI (выберите один)
5. *Рекомендуемый порядок загрузки*: Библиотеки → Граф зависимостей → Контент

== 🔗 Полезные ссылки

- CurseForge: https://www.curseforge.com/minecraft/mods
- Modrinth: https://modrinth.com
- GitHub: https://github.com

#h(1em)

_Каталог создан для версии Minecraft 1.20.1_
_Последнее обновление: 2024_

