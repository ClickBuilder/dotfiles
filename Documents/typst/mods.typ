#show "[": "(X)"
#show "]": "(√)"
#show "]1": "(100%√)"

#let mods(text) = {
  let rows = text
    .split("\n")
    .filter(x => x.trim() != "")

  table(
    columns: (2fr, 5fr),
    stroke: 0.5pt,

    [*Название*], [*Описание*],

    ..rows.map(row => {
      let parts = row.split("|")

      let url = parts.at(0).trim()
      let desc = if parts.len() > 1 {
        parts.at(1).trim()
      } else {
        ""
      }

      let slug = url.split("/").last()

      (
        link(url)[#slug],
        [#desc],
      )
    }).flatten()
  )
}

Сборка на 1.20.1

Utils

#mods("
https://modrinth.com/mod/villager-names-serilum | [ Именовать жителей
https://modrinth.com/mod/playerrevive | ]1 Возможность ресать 
")

Звук
#mods("
https://modrinth.com/plugin/simple-voice-chat | ]1 голосовой чат
https://modrinth.com/mod/sound-physics-remastered | ] Улучшение звука
https://modrinth.com/mod/presence-footsteps-forge | ] Улучшение звука передвижения
https://modrinth.com/mod/sound | ] Улучшенные звуки
")

Визуал/анимации

#mods("
https://modrinth.com/mod/not-enough-animations | ] Добавление анимации для вида со стороны
https://modrinth.com/plugin/emotecraft | ] Кидать свэг анимации
https://modrinth.com/datapack/spawn-animations/gallery | ]1 анимации спавна мобов
https://modrinth.com/mod/3dskinlayers | ]1 объёмные скины
https://modrinth.com/mod/advancement-plaques | ] Обновлённый визуал для достижений
https://modrinth.com/mod/boat-item-view | ] Преработка просмотра карты на лодке
https://modrinth.com/mod/subtle-effects | ]1 Эффекты света, бега, сна и т.д.
https://modrinth.com/mod/chunks-fade-in | ]1 Анимация для появления чанков
https://www.curseforge.com/minecraft/mc-mods/appleskin | ] Показывает насыщение еды
https://modrinth.com/mod/explosive-enhancement-forge | ]1 Визуал взрывов
https://modrinth.com/mod/itemphysic | ]1 физика предметов при выбрасывании
https://modrinth.com/mod/itemphysic-lite | ]1 тот же мод что и выше не знаю разницы
https://modrinth.com/mod/item-borders | ] Обводка вокруг шмоток
https://modrinth.com/mod/enhanced-boss-bars-mod | ] Перерисованный хп бар босса 
https://modrinth.com/mod/legendary-tooltips | ]1 Красивое отображение шмоток
https://modrinth.com/mod/better-third-person | ]1 Крутить камерой от третьего лица
https://modrinth.com/mod/punchy-fpa | ]1 Переработка анимаций от первого лица
https://modrinth.com/mod/item-highlighter | ]1 Подсветка новых подобранных премедтов
https://modrinth.com/mod/tool-stats | [ Статы шмоток 
https://modrinth.com/mod/damagenumbers | ]1 Цифры урона над бошкой
https://modrinth.com/mod/wither-spawn-animation | ] Анимация спавна визера
https://modrinth.com/mod/entity-model-features | ]1 Улучшение моделей мобов
https://modrinth.com/mod/inventory-particles | ]1 Эффекты в инвентаре
https://modrinth.com/mod/jade | ]1 HUD с инфой о блоках
https://modrinth.com/mod/particular-reforged | ]1 Визуальные частицы
https://modrinth.com/mod/resourcify/gallery | [ Менеджер ресурс паков
https://modrinth.com/mod/smooth-gui | ]1 Плавные анимации GUI
https://modrinth.com/mod/status-effect-bars-reforged | ]1 Таймеры эффектов 
https://modrinth.com/mod/wakes-reforged | ]1 Волны на воде
https://modrinth.com/mod/smooth-swapping | ]1 Плавные анимации перетаскивания предметов
https://modrinth.com/mod/visibility-toggle | ]1 Скрытие рамок
https://modrinth.com/mod/vanilla-refresh | ] Освежённый ванильный стиль
https://modrinth.com/mod/visuality-forge | ]1 Дополнительные визуальные эффекты
https://modrinth.com/mod/distanthorizons | ]1 Видеть дальше
https://modrinth.com/mod/shulkerboxtooltip | ]1 ВИдеть что в шалкерах
https://modrinth.com/mod/what-are-they-up-to | ]1 Если ты в инвенторе то другой игрок видит
")

Оптимизация
#mods("
https://www.curseforge.com/minecraft/mc-mods/badoptimizations | ] Мод для оптимизации, ориентированный на аспекты, не связанные с рендерингом
https://modrinth.com/mod/chunky | ]1 Заранее генерирует чанки
https://modrinth.com/mod/dynamic-fps | ]1 Снижает нагрузку в фоне
https://modrinth.com/mod/entityculling | ]1 Не рендерит скрытые сущности
https://modrinth.com/mod/fps-reducer | [ Экономит фпс в простое
https://modrinth.com/mod/immediatelyfast | [ Ускорение рендера GUI
https://modrinth.com/mod/radium | [ Оптимизация логики игры
https://modrinth.com/mod/noisiumed | [ Оптимизация генерации чанков
https://www.curseforge.com/minecraft/mc-mods/serverpingerfixer | [ Быстрый пинг серверов
https://modrinth.com/mod/sodium-extras | ]1 Буст фпс
https://modrinth.com/mod/sodium-dynamic-lights | ]1 Динамический свет
https://modrinth.com/mod/sodium-options-api | ]1 Конфигурация содиума
https://modrinth.com/mod/chloride | [ Увеличения функционала возможности увелечения фпс
https://modrinth.com/mod/cubes-without-borders | ]1 borderless fullscreen
https://modrinth.com/mod/vmp-forge | [ Оптимизация многопоточности 
https://modrinth.com/mod/asyncparticles | [ Асинхронно обрабатывает все партиклы
")

Шейдеры 
#mods("
")
Магия
#mods("
https://modrinth.com/mod/irons-spells-n-spellbooks | ]1 Какая то магия
https://modrinth.com/mod/enigmatic-legacy/gallery | ] Какая то магия
https://modrinth.com/mod/mystical-agriculture | ] Получать ресурсы с выращенных цветков
https://modrinth.com/mod/rings-of-ascension | [ Кольца
")
qol 

#mods("
https://modrinth.com/mod/bridging-mod | ]1 Более удобная установка блоков
https://modrinth.com/mod/healing-campfire | ] Костры хилят терарриz?
https://modrinth.com/mod/cold-sweat | ] Замерзаешь или перегреваешься
https://modrinth.com/datapack/timber-strike | ]1 Трикапитатор
https://modrinth.com/mod/betterf3 | [ улучшение F3 
https://modrinth.com/mod/clickthrough+ | ]1 Кликать сквозь рамки
https://modrinth.com/mod/inventory-profiles-next | ]1 Сортировка инвенторя
https://modrinth.com/mod/mouse-tweaks | ]1 Удобство пользования инвентарём 
https://modrinth.com/mod/rightclickharvest | ]1 Сбор уражая пкмом
https://www.curseforge.com/minecraft/mc-mods/true-darkness-forge-updated-fork| ]1 Темнее чёрного
https://modrinth.com/mod/wi-zoom | ]1 зум
https://modrinth.com/mod/jei | ]1 Видеть шмотки справа 
https://modrinth.com/mod/ironchests | ]1 улучшенные сундуки
")
Моды 
#mods("
https://modrinth.com/mod/travelersbackpack | [ Говнистый дизайн, некоторые сумки перебаф.
https://modrinth.com/mod/brewn-chew | ]1 Накладывать зелья на еду

")
еда
#mods("
https://modrinth.com/mod/more-delight | ]1 новая жрачка
")
movement
#mods("
https://modrinth.com/mod/combat-roll | ]1 кувырки 
")
mobs

#mods("
https://modrinth.com/mod/nyfs-spiders | [ ебанутые пауки
https://modrinth.com/datapack/edf-remastered | ]1 Переработка драки с драконом 
https://modrinth.com/datapack/mob-captains | ]1 Ванильный усиленный моб с крутым дропом
https://modrinth.com/mod/mowzies-mobs | [ Мобы кал
")

События 
#mods("
https://modrinth.com/mod/enhanced-celestials | ]1 События в зависимости от цвета луны
https://modrinth.com/mod/realm-rpg-fallen-adventurers | [ Появляются прикольные скелеты в мире
https://modrinth.com/mod/weather-storms-tornadoes | ]1 Шторм
https://modrinth.com/mod/sanity-descent-into-madness | [ шакала сумашествия
https://modrinth.com/mod/the-hordes | ]1 Орды зомпи
")
Приключение

#mods("
https://modrinth.com/mod/l_enders-cataclysm | ]1 подземелья, сражения с боссами, новые предметы
https://modrinth.com/mod/deeperdarker/gallery | ]1 Обновлённый биом варденом
https://modrinth.com/mod/artifacts | [ Каловый дизайн Новые шмотки с бонусками
https://modrinth.com/mod/relics-mod | ]1 Бонуски в доп слоты
https://modrinth.com/mod/antique-atlas-4 | ]1 Атлас
https://modrinth.com/mod/minecells | ]1 Чтоо дед целс
https://modrinth.com/mod/terramity | ]1 Чтоо террария
https://modrinth.com/mod/bossesrise |]1 Новые противники
https://modrinth.com/mod/origins | ] Возможность выбрать расу со своими бонусками и дебафами
https://modrinth.com/datapack/rpg-origins | ] Рпгшные расы
https://modrinth.com/mod/divinerpg | ]1 Divine RPG база
https://modrinth.com/mod/borninchaos | ]1 новые агрессивные моды шмотки и структуры
https://modrinth.com/mod/aether | ]1 Ебать рай
https://modrinth.com/mod/deep-aether | ]1 Ебать рай улучшен
https://modrinth.com/mod/when-dungeons-arise | ]1 Новые данжи
https://modrinth.com/mod/adventofascension | ]1 Что то по типу divine rpg
")
Усложнения 
#mods("
https://modrinth.com/mod/realistic-torches ]1

")
Технологии

#mods("
https://modrinth.com/mod/immersive-aircraft | ]1 Самолёт
https://modrinth.com/mod/create | ]1 механизмы
https://modrinth.com/mod/create-steam-n-rails | ]1 Поезды
https://modrinth.com/mod/hbm-ntm-high-edition | [ Ебанутая хуйня
https://modrinth.com/mod/enderio | [ Мало о чём говорит
https://modrinth.com/mod/ae2 | [ Систмы хранения, авто-крафт, сеть и каналы

")
Древо умений
#mods("
https://modrinth.com/mod/skills | ] древо умений не совсем понял чё там надо тестить
https://modrinth.com/datapack/default-skill-trees | ] такой же непонятный кал
")
Животные
#mods("
https://modrinth.com/mod/alexs-mobs | [ 85+ существ животных
")

Боёвка

#mods("
")

Структуры/биомы/миры

#mods("
https://modrinth.com/mod/biomes-o-plenty | ] Новые биомы в игре
https://modrinth.com/mod/yungs-better-nether-fortresses | ] Переработка адской крепости
https://modrinth.com/mod/yungs-better-ocean-monuments | ] Переработка океанского данжа
https://modrinth.com/mod/yungs-better-dungeons | ] Переработка ванильных данжей
https://modrinth.com/mod/yungs-better-jungle-temples | ] Переработка данжа в джунглях
https://modrinth.com/mod/yungs-better-mineshafts | ] Переработка шахт
https://modrinth.com/mod/yungs-better-end-island | ] Переработка края
https://modrinth.com/mod/yungs-better-strongholds | ] Переработка стронгхолда
https://modrinth.com/mod/yungs-better-witch-huts | ] Переработка домов ведьм
https://modrinth.com/mod/yungs-better-desert-temples | ] Переработка пустнных данжей
https://modrinth.com/mod/yungs-bridges | ] Добавление в мир мостов 
https://modrinth.com/mod/yungs-cave-biomes | ] Биомы пещер
https://modrinth.com/mod/yungs-better-caves | ] Переработка пещер
https://modrinth.com/mod/towns-and-towers | ] Новые структуры с деревнями и грабителями
")

Библиотеки
#mods("
https://modrinth.com/mod/curios | Акссесуары
")

#mods("
https://modrinth.com/mod/immersive-melodies | ]1 Для репа с моим бро
")

#mods("
https://www.curseforge.com/minecraft/mc-mods/entropy | [ Норм работает только со зрителями. Хаос кал события ютуб смех залить гта 5 машины падают с небес
")
