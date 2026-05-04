#import <UIKit/UIKit.h>
#import "ATConfigViewController.h"
#import "ATTypingManager.h"

// Интерфейс для UIKeyboardLayoutStar (приватный API)
@interface UIKeyboardLayoutStar : UIView
- (UIView *)viewForKey:(NSString *)key;
@end

@interface UIKBTree : NSObject
@property (nonatomic, copy) NSString *representedString;
@property (nonatomic, copy) NSString *displayString;
@end

@interface UIKeyboardImpl : UIView
+ (instancetype)sharedInstance;
- (void)insertText:(NSString *)text;
- (void)handleKeyEvent:(id)event;
@end

static ATTypingManager *typingManager = nil;
static UIView *highlightView = nil;

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
        
        if ([self respondsToSelector:@selector(key)]) {
            UIKBTree *key = [self valueForKey:@"key"];
            if (key && [key respondsToSelector:@selector(representedString)]) {
                keyText = key.representedString;
            }
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
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
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
                [weakSelf at_highlightKey:character];
            });
        };
    }
}

%new
- (void)at_highlightKey:(NSString *)character {
    // Находим view для клавиши
    UIView *keyView = [self viewForKey:character];
    
    if (!keyView) {
        // Пробуем найти по другим вариантам
        keyView = [self viewForKey:[character uppercaseString]];
    }
    
    if (keyView) {
        // Создаем эффект подсветки
        if (highlightView) {
            [highlightView removeFromSuperview];
        }
        
        highlightView = [[UIView alloc] initWithFrame:keyView.bounds];
        highlightView.backgroundColor = [[UIColor systemBlueColor] colorWithAlphaComponent:0.3];
        highlightView.layer.cornerRadius = 5;
        highlightView.userInteractionEnabled = NO;
        [keyView addSubview:highlightView];
        
        // Анимация подсветки
        [UIView animateWithDuration:0.1 animations:^{
            highlightView.alpha = 1.0;
            highlightView.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 delay:0.05 options:0 animations:^{
                highlightView.alpha = 0.0;
                highlightView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [highlightView removeFromSuperview];
                highlightView = nil;
            }];
        }];
    }
}

%end

%ctor {
    %init;
    typingManager = [ATTypingManager sharedManager];
}
