#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ATConfigViewController.h"
#import "ATTypingManager.h"

// Интерфейсы для приватных API
@interface UIKBTree : NSObject
@property (nonatomic, copy) NSString *representedString;
@property (nonatomic, copy) NSString *displayString;
@end

@interface UIKBKeyView : UIView
- (UIKBTree *)key;
@end

@interface UIKeyboardLayoutStar : UIView
@end

@interface UIKeyboardImpl : UIView
+ (instancetype)sharedInstance;
- (void)insertText:(NSString *)text;
- (void)handleKeyEvent:(id)event;
@end

static ATTypingManager *typingManager = nil;

// Хук для обработки долгого нажатия на кнопку "2"
%hook UIKBKeyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = %orig;
    
    if (self) {
        // Добавляем распознаватель долгого нажатия только для кнопки "2"
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] 
            initWithTarget:self 
            action:@selector(at_handleLongPress:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
    }
    
    return self;
}

%new
- (void)at_handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Проверяем, что это кнопка "2"
        NSString *keyText = nil;
        
        UIKBTree *key = [self key];
        if (key && key.representedString) {
            keyText = key.representedString;
        }
        
        if ([keyText isEqualToString:@"2"]) {
            // Вибрация при открытии меню
            AudioServicesPlaySystemSound(1519);
            
            // Показываем меню автотайпера
            [self at_showAutoTyperMenu];
        }
    }
}

%new
- (void)at_showAutoTyperMenu {
    // Получаем активное окно правильным способом для iOS 13+
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    
    if (!keyWindow) {
        keyWindow = [UIApplication sharedApplication].windows.firstObject;
    }
    
    UIViewController *rootVC = keyWindow.rootViewController;
    
    // Находим topmost view controller
    while (rootVC.presentedViewController) {
        rootVC = rootVC.presentedViewController;
    }
    
    ATConfigViewController *configVC = [[ATConfigViewController alloc] init];
    configVC.modalPresentationStyle = UIModalPresentationPageSheet;
    
    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *sheet = configVC.sheetPresentationController;
        sheet.detents = @[
            [UISheetPresentationControllerDetent mediumDetent],
            [UISheetPresentationControllerDetent largeDetent]
        ];
        sheet.prefersGrabberVisible = YES;
    }
    
    [rootVC presentViewController:configVC animated:YES completion:nil];
}

%end

// Хук для подсветки клавиш при автоматическом вводе
%hook UIKeyboardLayoutStar

- (void)didMoveToWindow {
    %orig;
    
    if (!typingManager) {
        typingManager = [ATTypingManager sharedManager];
        
        // Callback для подсветки клавиш
        __weak UIKeyboardLayoutStar *weakSelf = self;
        typingManager.onCharacterTyped = ^(NSString *character) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf performSelector:@selector(at_highlightKey:) withObject:character];
            });
        };
    }
}

%new
- (void)at_highlightKey:(NSString *)character {
    // Простая подсветка без поиска конкретной клавиши
    // Создаем визуальный эффект в центре клавиатуры
    
    UIView *flashView = [[UIView alloc] initWithFrame:CGRectMake(
        self.bounds.size.width / 2 - 20,
        self.bounds.size.height / 2 - 20,
        40,
        40
    )];
    flashView.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.5];
    flashView.layer.cornerRadius = 20;
    flashView.userInteractionEnabled = NO;
    [self addSubview:flashView];
    
    // Анимация
    [UIView animateWithDuration:0.2 animations:^{
        flashView.alpha = 0.0;
        flashView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

%end

%ctor {
    %init;
    typingManager = [ATTypingManager sharedManager];
}
