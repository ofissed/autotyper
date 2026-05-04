# Настройка GitHub Secrets для сборки IPA

Для автоматической сборки .ipa через GitHub Actions нужно настроить секреты в репозитории.

## Необходимые секреты

Перейдите в Settings → Secrets and variables → Actions → New repository secret

### 1. BUILD_CERTIFICATE_BASE64
Сертификат разработчика в формате .p12, закодированный в base64

**Как получить:**
```bash
# Экспортируйте сертификат из Keychain в .p12
# Затем конвертируйте в base64:
base64 -i Certificates.p12 | pbcopy
```

### 2. P12_PASSWORD
Пароль для .p12 сертификата (который вы указали при экспорте)

### 3. PROVISIONING_PROFILE_BASE64
Provisioning profile в base64

**Как получить:**
```bash
# Скачайте .mobileprovision из Apple Developer Portal
base64 -i YourProfile.mobileprovision | pbcopy
```

### 4. KEYCHAIN_PASSWORD
Любой пароль для временного keychain (например: `temp-keychain-password`)

### 5. EXPORT_OPTIONS_PLIST
ExportOptions.plist в base64

**Как получить:**
```bash
base64 -i ExportOptions.plist | pbcopy
```

## Пошаговая инструкция

### Шаг 1: Получите сертификат разработчика
1. Откройте Xcode → Preferences → Accounts
2. Выберите ваш Apple ID → Manage Certificates
3. Создайте "Apple Development" или "Apple Distribution" сертификат

### Шаг 2: Экспортируйте сертификат
1. Откройте Keychain Access
2. Найдите ваш сертификат в категории "My Certificates"
3. Правый клик → Export → сохраните как .p12
4. Установите пароль

### Шаг 3: Получите Provisioning Profile
1. Зайдите на [Apple Developer Portal](https://developer.apple.com/account)
2. Certificates, Identifiers & Profiles → Profiles
3. Создайте или скачайте существующий профиль
4. Скачайте .mobileprovision файл

### Шаг 4: Настройте ExportOptions.plist
Отредактируйте файл `ExportOptions.plist`:
```xml
<key>method</key>
<string>development</string> <!-- или app-store, ad-hoc, enterprise -->
<key>teamID</key>
<string>YOUR_TEAM_ID</string> <!-- Ваш Team ID из Developer Portal -->
```

### Шаг 5: Добавьте секреты в GitHub
1. Конвертируйте все файлы в base64
2. Добавьте их как секреты в GitHub
3. Запустите workflow

## Альтернатива: Fastlane

Для более простой настройки можно использовать Fastlane:

```bash
# Установка
gem install fastlane

# Инициализация
cd MyiOSApp
fastlane init

# Настройка match для управления сертификатами
fastlane match init
```

## Проверка

После настройки секретов:
1. Сделайте commit и push в main ветку
2. Перейдите в Actions на GitHub
3. Проверьте статус сборки
4. Скачайте .ipa из Artifacts после успешной сборки

## Troubleshooting

**Ошибка "No signing certificate":**
- Проверьте правильность base64 кодирования
- Убедитесь, что сертификат не истек

**Ошибка "No provisioning profile":**
- Проверьте Bundle ID в проекте и профиле
- Убедитесь, что профиль не истек

**Ошибка при экспорте IPA:**
- Проверьте ExportOptions.plist
- Убедитесь, что teamID указан правильно
