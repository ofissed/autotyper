#import "ATConfigViewController.h"
#import "ATTypingManager.h"

@interface ATConfigViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UITextField *speedTextField;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation ATConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupUI];
    [self loadSettings];
    
    // Обновляем статус
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateStatus) userInfo:nil repeats:YES];
}

- (void)setupUI {
    // Заголовок
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"⚡️ AutoTyper";
    self.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleLabel];
    
    // Скорость
    self.speedLabel = [[UILabel alloc] init];
    self.speedLabel.text = @"Скорость (слов/мин):";
    self.speedLabel.font = [UIFont systemFontOfSize:16];
    self.speedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.speedLabel];
    
    self.speedTextField = [[UITextField alloc] init];
    self.speedTextField.placeholder = @"60";
    self.speedTextField.text = @"60";
    self.speedTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.speedTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.speedTextField.textAlignment = NSTextAlignmentCenter;
    self.speedTextField.delegate = self;
    self.speedTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.speedTextField];
    
    // Текст
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.text = @"Текст для ввода:";
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textLabel];
    
    self.textView = [[UITextView alloc] init];
    self.textView.text = @"Привет! Это автоматический ввод текста.";
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.layer.borderColor = [UIColor systemGray4Color].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 8;
    self.textView.delegate = self;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textView];
    
    // Кнопка старт
    self.startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.startButton setTitle:@"▶️ Начать печать" forState:UIControlStateNormal];
    self.startButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.startButton.backgroundColor = [UIColor systemBlueColor];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startButton.layer.cornerRadius = 12;
    [self.startButton addTarget:self action:@selector(startTyping) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.startButton];
    
    // Кнопка стоп
    self.stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.stopButton setTitle:@"⏹ Остановить" forState:UIControlStateNormal];
    self.stopButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.stopButton.backgroundColor = [UIColor systemRedColor];
    [self.stopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.stopButton.layer.cornerRadius = 12;
    [self.stopButton addTarget:self action:@selector(stopTyping) forControlEvents:UIControlEventTouchUpInside];
    self.stopButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.stopButton];
    
    // Статус
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"Готов к работе";
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor systemGrayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // Constraints
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:20],
        [self.titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        
        [self.speedLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:30],
        [self.speedLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        
        [self.speedTextField.centerYAnchor constraintEqualToAnchor:self.speedLabel.centerYAnchor],
        [self.speedTextField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.speedTextField.widthAnchor constraintEqualToConstant:100],
        [self.speedTextField.heightAnchor constraintEqualToConstant:40],
        
        [self.textLabel.topAnchor constraintEqualToAnchor:self.speedLabel.bottomAnchor constant:20],
        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        
        [self.textView.topAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor constant:8],
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.textView.heightAnchor constraintEqualToConstant:120],
        
        [self.startButton.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:20],
        [self.startButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.startButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.startButton.heightAnchor constraintEqualToConstant:50],
        
        [self.stopButton.topAnchor constraintEqualToAnchor:self.startButton.bottomAnchor constant:12],
        [self.stopButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.stopButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [self.stopButton.heightAnchor constraintEqualToConstant:50],
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.stopButton.bottomAnchor constant:12],
        [self.statusLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)startTyping {
    NSInteger speed = [self.speedTextField.text integerValue];
    if (speed <= 0) {
        speed = 60;
    }
    
    NSString *text = self.textView.text;
    if (text.length == 0) {
        [self showAlert:@"Ошибка" message:@"Введите текст для печати"];
        return;
    }
    
    // Сохраняем настройки
    [self saveSettings];
    
    // Закрываем меню
    [self dismissViewControllerAnimated:YES completion:^{
        // Запускаем автоввод
        [[ATTypingManager sharedManager] startTypingText:text withSpeed:speed];
    }];
}

- (void)stopTyping {
    [[ATTypingManager sharedManager] stopTyping];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateStatus {
    if ([ATTypingManager sharedManager].isTyping) {
        self.statusLabel.text = @"⚡️ Печатаю...";
        self.statusLabel.textColor = [UIColor systemGreenColor];
    } else {
        self.statusLabel.text = @"Готов к работе";
        self.statusLabel.textColor = [UIColor systemGrayColor];
    }
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.speedTextField.text forKey:@"ATSpeed"];
    [defaults setObject:self.textView.text forKey:@"ATText"];
    [defaults synchronize];
}

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *speed = [defaults objectForKey:@"ATSpeed"];
    NSString *text = [defaults objectForKey:@"ATText"];
    
    if (speed) {
        self.speedTextField.text = speed;
    }
    if (text) {
        self.textView.text = text;
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
