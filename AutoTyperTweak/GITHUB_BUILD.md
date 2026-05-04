# Сборка твика через GitHub Actions

## Автоматическая сборка

Твик автоматически собирается на GitHub при каждом push!

### Как это работает:

1. **Push в репозиторий:**
```bash
git add .
git commit -m "Update tweak"
git push
```

2. **GitHub Actions автоматически:**
   - Устанавливает Theos на macOS
   - Скачивает iOS SDK
   - Собирает .deb пакет
   - Загружает готовый .deb в Artifacts

3. **Скачать .deb:**
   - Зайди в репозиторий на GitHub
   - Actions → выбери последний workflow
   - Прокрути вниз до "Artifacts"
   - Скачай "AutoTyper-DEB"

## Установка на устройство

### Способ 1: Через Filza (проще всего)

1. Скачай .deb файл из GitHub Artifacts
2. Перекинь на iPhone (AirDrop, облако, etc.)
3. Открой в Filza
4. Нажми на .deb → Install
5. Respring (перезагрузка SpringBoard)

### Способ 2: Через SSH

```bash
# Скачай .deb с GitHub
# Подключись к iPhone
ssh root@192.168.1.XXX  # пароль: alpine (по умолчанию)

# Скопируй .deb на устройство
scp com.yourname.autotyper_1.0.0_iphoneos-arm.deb root@192.168.1.XXX:/tmp/

# Установи
ssh root@192.168.1.XXX
dpkg -i /tmp/com.yourname.autotyper_1.0.0_iphoneos-arm.deb
killall -9 SpringBoard
```

### Способ 3: Через Cydia/Sileo (для своего репозитория)

Если хочешь создать свой репозиторий:

1. Создай отдельный репозиторий на GitHub
2. Включи GitHub Pages
3. Добавь структуру Cydia репозитория
4. Добавь репозиторий в Cydia/Sileo на устройстве

## Создание релиза

Для автоматического создания релиза с .deb файлом:

```bash
# Создай тег
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions автоматически создаст Release с прикрепленным .deb файлом!

## Быстрый старт

```bash
# 1. Загрузи проект на GitHub
git init
git add .
git commit -m "Initial commit - AutoTyper tweak"
git remote add origin https://github.com/USERNAME/REPO.git
git branch -M main
git push -u origin main

# 2. Дождись окончания сборки (зеленая галочка)

# 3. Скачай .deb из Actions → Artifacts

# 4. Установи на джейлбрейкнутый iPhone

# 5. Готово! Зажми "2" на клавиатуре
```

## Troubleshooting

**Сборка падает с ошибкой:**
- Проверь что все файлы на месте
- Посмотри логи в Actions

**Не могу скачать .deb:**
- Artifacts доступны только 90 дней
- Создай релиз (git tag) для постоянного хранения

**Твик не работает после установки:**
```bash
# Переустанови
dpkg -r com.yourname.autotyper
dpkg -i com.yourname.autotyper_1.0.0_iphoneos-arm.deb
killall -9 SpringBoard
```

## Структура .deb пакета

После сборки получишь:
```
com.yourname.autotyper_1.0.0_iphoneos-arm.deb
```

Внутри:
```
/Library/MobileSubstrate/DynamicLibraries/
├── AutoTyper.dylib  # Основной твик
└── AutoTyper.plist  # Конфигурация
```

## Обновление твика

1. Измени код
2. Обнови версию в `control` файле
3. Push на GitHub
4. Скачай новый .deb
5. Установи поверх старой версии

## Создание собственного репозитория Cydia

Если хочешь распространять через Cydia/Sileo:

1. Создай репозиторий `cydia-repo` на GitHub
2. Добавь структуру:
```
cydia-repo/
├── Packages
├── Packages.bz2
├── Release
└── debs/
    └── com.yourname.autotyper_1.0.0_iphoneos-arm.deb
```

3. Включи GitHub Pages
4. Добавь в Cydia: `https://username.github.io/cydia-repo`

Подробнее: https://github.com/Sileo/Sileo/wiki/Creating-a-Repository
