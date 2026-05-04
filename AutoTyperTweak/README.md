# AutoTyper - iOS Tweak

Твик для автоматического ввода текста на джейлбрейкнутых iOS устройствах.

## Возможности

- 🎯 Зажмите кнопку "2" на клавиатуре для открытия меню
- ⚡️ Настраиваемая скорость печати (слов в минуту)
- 💡 Подсветка клавиш при автоматическом вводе
- 📱 Работает в любом приложении (Messages, Notes, Safari и т.д.)
- 💾 Сохранение настроек
- 🔊 Тактильная обратная связь

## Установка

### Требования
- Джейлбрейкнутое iOS устройство (iOS 13.0+)
- Theos установлен на Mac/Linux

### Сборка

```bash
cd AutoTyperTweak
make package
```

### Установка на устройство

```bash
# Через SSH
make package install

# Или вручную
# Скопируйте .deb файл на устройство
# Установите через Filza или dpkg
```

### Установка через репозиторий

1. Добавьте репозиторий в Cydia/Sileo
2. Найдите "AutoTyper"
3. Установите

## Использование

1. Откройте любое приложение с текстовым полем
2. Откройте клавиатуру
3. **Зажмите кнопку "2"** на 0.5 секунды
4. Откроется меню AutoTyper
5. Настройте скорость и текст
6. Нажмите "Начать печать"
7. Закройте меню - текст начнет печататься автоматически
8. Клавиши будут подсвечиваться при нажатии

## Настройки

- **Скорость**: количество слов в минуту (по умолчанию 60)
- **Текст**: текст для автоматического ввода
- Настройки сохраняются автоматически

## Установка Theos (для сборки)

### На Mac:

```bash
# Установите зависимости
brew install ldid xz

# Клонируйте Theos
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos

# Добавьте в ~/.zshrc или ~/.bash_profile
export THEOS=/opt/theos
export PATH=$THEOS/bin:$PATH
```

### На Linux:

```bash
# Установите зависимости
sudo apt-get install fakeroot git perl clang build-essential

# Клонируйте Theos
sudo git clone --recursive https://github.com/theos/theos.git /opt/theos

# Добавьте в ~/.bashrc
export THEOS=/opt/theos
export PATH=$THEOS/bin:$PATH
```

### Настройка для iOS:

```bash
# Скачайте iOS SDK
curl -LO https://github.com/theos/sdks/archive/master.zip
unzip master.zip
mv sdks-master/*.sdk $THEOS/sdks/
rm -rf master.zip sdks-master
```

## Сборка и установка

```bash
# Перейдите в папку твика
cd AutoTyperTweak

# Соберите пакет
make package

# Установите на устройство (через SSH)
# Убедитесь что устройство подключено к той же сети
export THEOS_DEVICE_IP=192.168.1.XXX  # IP вашего устройства
export THEOS_DEVICE_PORT=22
make package install

# Или установите вручную
# .deb файл будет в папке packages/
# Скопируйте на устройство и установите через Filza
```

## Troubleshooting

**Меню не открывается:**
- Убедитесь что зажимаете именно кнопку "2"
- Держите 0.5 секунды
- Проверьте что твик установлен: `dpkg -l | grep autotyper`

**Клавиши не подсвечиваются:**
- Это нормально для некоторых кастомных клавиатур
- Работает только со стандартной iOS клавиатурой

**Текст не печатается:**
- Проверьте что приложение не блокирует программный ввод
- Некоторые приложения (банковские) могут блокировать

**После установки ничего не работает:**
- Сделайте respring: `killall -9 SpringBoard`
- Или перезагрузите устройство

## Разработка

Структура проекта:
```
AutoTyperTweak/
├── Makefile              # Конфигурация сборки
├── control               # Метаданные пакета
├── Tweak.x               # Основной код (Logos)
├── ATTypingManager.h/m   # Менеджер автоввода
└── ATConfigViewController.h/m  # UI меню
```

## Лицензия

MIT License

## Автор

YourName

## Поддержка

- iOS 13.0 - 16.x
- Все джейлбрейки (checkra1n, unc0ver, Taurine, etc.)
