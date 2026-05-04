# AutoTyper - iOS Tweak

Твик для автоматического ввода текста на джейлбрейкнутых iOS устройствах.

## 🎯 Возможности

- **Зажми кнопку "2"** на клавиатуре для открытия меню
- Настройка скорости печати (слов в минуту)
- Подсветка клавиш при автоматическом вводе
- Работает в любом приложении (Messages, Notes, Safari и т.д.)
- Автоматическая сборка через GitHub Actions
- Полностью бесплатно!

## 📦 Установка

### Требования
- Джейлбрейкнутое iOS устройство (iOS 13.0+)
- Cydia, Sileo или Filza

### Быстрая установка

1. Скачай .deb файл из [Releases](../../releases) или [Actions](../../actions)
2. Установи через Filza или dpkg
3. Respring
4. Зажми "2" на клавиатуре!

Подробная инструкция: [AutoTyperTweak/GITHUB_BUILD.md](AutoTyperTweak/GITHUB_BUILD.md)

## Требования

- Xcode 14.0+
- iOS 15.0+
- Swift 5.7+
- Apple Developer Account (для подписи и распространения)

## Структура проекта

```
MyiOSApp/
├── MyiOSApp/           # Основной код приложения
├── MyiOSApp.xcodeproj  # Проект Xcode
└── README.md           # Документация
```

## Сборка .ipa файла

### Через Xcode:
1. Откройте проект в Xcode
2. Выберите схему и устройство (Generic iOS Device)
3. Product → Archive
4. Distribute App → выберите метод распространения

### Через командную строку:
```bash
# Сборка архива
xcodebuild -project MyiOSApp.xcodeproj -scheme MyiOSApp -configuration Release archive -archivePath build/MyiOSApp.xcarchive

# Экспорт .ipa
xcodebuild -exportArchive -archivePath build/MyiOSApp.xcarchive -exportPath build -exportOptionsPlist ExportOptions.plist
```

## Автоматическая сборка через GitHub Actions

Проект настроен для автоматической сборки .ipa через GitHub Actions.

### Настройка:
1. Следуйте инструкциям в `SETUP_GITHUB_SECRETS.md`
2. Добавьте необходимые секреты в Settings → Secrets
3. Push в main ветку запустит сборку
4. Скачайте .ipa из Artifacts после сборки

### Workflows:
- `build-ipa.yml` - полная сборка с подписью и экспортом .ipa
- `build-simple.yml` - простая сборка и тесты для проверки кода

## Установка

После создания .ipa файла, вы можете:
- Загрузить в App Store Connect через Transporter
- Распространить через TestFlight
- Установить через Apple Configurator или другие MDM решения
