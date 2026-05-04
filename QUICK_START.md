# Быстрый старт - Сборка на GitHub

## Шаг 1: Загрузить проект на GitHub

```bash
# Инициализируй git
git init
git add .
git commit -m "Initial commit - Автотайпер"

# Создай репозиторий на GitHub.com, затем:
git remote add origin https://github.com/ВАШ_USERNAME/ВАШ_РЕПО.git
git branch -M main
git push -u origin main
```

## Шаг 2: Создать Xcode проект (ВАЖНО!)

GitHub Actions не может собрать без .xcodeproj файла. Есть 2 варианта:

### Вариант А: Создать проект в Xcode (рекомендуется)

1. Открой Xcode
2. File → New → Project
3. Выбери "App" → Next
4. Название: `MyiOSApp`
5. Bundle Identifier: `com.yourname.MyiOSApp`
6. Сохрани в папку проекта
7. Удали созданные Xcode файлы (ViewController.swift, AppDelegate.swift)
8. Добавь наши файлы в проект (правый клик на папку → Add Files)
9. Commit и push:
```bash
git add MyiOSApp.xcodeproj
git commit -m "Add Xcode project"
git push
```

### Вариант Б: Использовать Swift Package Manager

Создам Package.swift для сборки без Xcode проекта (но .ipa все равно нужен Xcode).

## Шаг 3: Получить сертификаты Apple

### 3.1 Зарегистрируйся в Apple Developer
- Зайди на https://developer.apple.com
- Нужен платный аккаунт ($99/год) для сборки .ipa

### 3.2 Создай App ID
1. Зайди в https://developer.apple.com/account
2. Certificates, Identifiers & Profiles → Identifiers
3. Нажми "+" → App IDs
4. Bundle ID: `com.yourname.MyiOSApp`

### 3.3 Создай сертификат
1. Certificates → "+"
2. Выбери "Apple Development" (для тестирования)
3. Скачай сертификат
4. Двойной клик - установится в Keychain

### 3.4 Создай Provisioning Profile
1. Profiles → "+"
2. Выбери "iOS App Development"
3. Выбери App ID
4. Выбери сертификат
5. Выбери устройства (если нужно)
6. Скачай .mobileprovision файл

## Шаг 4: Настроить GitHub Secrets

### 4.1 Экспортируй сертификат в .p12
```bash
# Открой Keychain Access
# Найди "Apple Development: ваш email"
# Правый клик → Export
# Сохрани как Certificates.p12
# Установи пароль (например: mypassword123)
```

### 4.2 Конвертируй в base64
```bash
# На Mac:
base64 -i Certificates.p12 | pbcopy

# На Windows (PowerShell):
[Convert]::ToBase64String([IO.File]::ReadAllBytes("Certificates.p12")) | Set-Clipboard

# На Linux:
base64 Certificates.p12 | xclip -selection clipboard
```

### 4.3 Конвертируй provisioning profile
```bash
# Mac:
base64 -i YourProfile.mobileprovision | pbcopy

# Windows:
[Convert]::ToBase64String([IO.File]::ReadAllBytes("YourProfile.mobileprovision")) | Set-Clipboard
```

### 4.4 Конвертируй ExportOptions.plist
Сначала отредактируй `ExportOptions.plist`:
```xml
<key>teamID</key>
<string>ТВОЙ_TEAM_ID</string>  <!-- Найди на developer.apple.com -->
```

Затем:
```bash
# Mac:
base64 -i ExportOptions.plist | pbcopy

# Windows:
[Convert]::ToBase64String([IO.File]::ReadAllBytes("ExportOptions.plist")) | Set-Clipboard
```

### 4.5 Добавь секреты в GitHub
1. Открой репозиторий на GitHub.com
2. Settings → Secrets and variables → Actions
3. Нажми "New repository secret"
4. Добавь каждый секрет:

| Имя секрета | Значение |
|-------------|----------|
| `BUILD_CERTIFICATE_BASE64` | base64 из Certificates.p12 |
| `P12_PASSWORD` | Пароль от .p12 (например: mypassword123) |
| `PROVISIONING_PROFILE_BASE64` | base64 из .mobileprovision |
| `KEYCHAIN_PASSWORD` | Любой пароль (например: temp-password) |
| `EXPORT_OPTIONS_PLIST` | base64 из ExportOptions.plist |

## Шаг 5: Запустить сборку

### Автоматически:
```bash
git add .
git commit -m "Update app"
git push
```
Сборка запустится автоматически!

### Вручную:
1. Зайди в репозиторий на GitHub
2. Actions → "Build iOS IPA"
3. Run workflow → Run workflow

## Шаг 6: Скачать .ipa

1. Дождись окончания сборки (зеленая галочка)
2. Открой завершенный workflow
3. Прокрути вниз до "Artifacts"
4. Скачай "MyiOSApp-IPA"

## Упрощенный вариант (без сертификатов)

Если нет Apple Developer аккаунта, можно собрать только для симулятора:

1. Используй workflow `build-simple.yml`
2. Он соберет проект без подписи
3. Но .ipa для реального устройства не получится

## Troubleshooting

**"No such file or directory: MyiOSApp.xcodeproj"**
→ Нужно создать Xcode проект (Шаг 2)

**"Code signing error"**
→ Проверь правильность base64 и Team ID

**"Provisioning profile doesn't match"**
→ Bundle ID в проекте должен совпадать с Bundle ID в профиле

**"No Apple Developer account"**
→ Нужен платный аккаунт для сборки .ipa

## Альтернатива: Fastlane Match

Для автоматизации управления сертификатами:
```bash
gem install fastlane
fastlane match init
```

Fastlane может хранить сертификаты в отдельном git репозитории.
