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
- (void)setKey:(UIKBTree *)key;
@end

// Категория для объявления новых методов
@interface UIKBKeyView (AutoTyper)
- (void)at_handleLongPress:(UILongPressGestureRecognizer *)gesture;
- (void)at_showAutoTyperMenu;
@end

@interface UIScene : NSObject
@end

@interface UIWindowScene : UIScene
@property (nonatomic, readonly) NSArray<UIWindow *> *windows;
@end

@interface UIKeyboardLayoutStar : UIView
@end

// Категория для подсветки
@interface UIKeyboardLayoutStar (AutoTyper)
- (void)at_highlightKey:(NSString *)character;
@end

@interface UIKeyboardImpl : UIView
+ (instancetype)sharedInstance;
- (void)insertText:(NSString *)text;
- (void)handleKeyEvent:(id)event;
@end

static ATTypingManager *typingManager = nil;

// Хук для обработки долгого нажатия на кнопку "2"
%hook UIKBKeyView

- (void)setKey:(UIKBTree *)key {
    %orig;
    
    if (![key.representedString isEqualToString:@"2"]) return;
    
    // чтобы не добавлялся 100 раз
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        if ([g isKindOfClass:[UILongPressGestureRecognizer class]]) return;
    }
    
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
        action:@selector(at_handleLongPress:)];
    
    longPress.minimumPressDuration = 0.5;
    
    [self addGestureRecognizer:longPress];
    
    NSLog(@"🔥 gesture added to key 2");
}

%new
- (void)at_handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state != UIGestureRecognizerStateBegan) return;
    
    AudioServicesPlaySystemSound(1519);
    
    NSLog(@"🔥 LONG PRESS WORKED");
    
    [self at_showAutoTyperMenu];
}

%new
- (void)at_showAutoTyperMenu {
    // Получаем активное окно для iOS 13+
    UIWindow *keyWindow = nil;
    
    NSSet *scenes = [UIApplication sharedApplication].connectedScenes;
    for (UIScene *scene in scenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *window in windowScene.windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
            if (keyWindow) break;
        }
    }
    
    if (!keyWindow) {
        // Fallback для старых версий
        keyWindow = [UIApplication sharedApplication].delegate.window;
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
        UIKeyboardLayoutStar *strongSelf = self;
        typingManager.onCharacterTyped = ^(NSString *character) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf performSelector:@selector(at_highlightKey:) withObject:character];
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
    NSLog(@"🔥 AutoTyper LOADED");
    typingManager = [ATTypingManager sharedManager];
    %init;
}
