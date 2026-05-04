#import "ATTypingManager.h"
#import <UIKit/UIKit.h>

@interface UIKeyboardImpl : UIView
+ (instancetype)sharedInstance;
- (void)insertText:(NSString *)text;
@end

@interface ATTypingManager ()
@property (nonatomic, strong) NSTimer *typingTimer;
@property (nonatomic, strong) NSString *textToType;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation ATTypingManager

+ (instancetype)sharedManager {
    static ATTypingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ATTypingManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isTyping = NO;
        _currentIndex = 0;
    }
    return self;
}

- (void)startTypingText:(NSString *)text withSpeed:(NSInteger)wpm {
    if (self.isTyping) {
        [self stopTyping];
    }
    
    self.textToType = text;
    self.currentIndex = 0;
    self.isTyping = YES;
    
    // Рассчитываем интервал между символами
    // Средняя длина слова = 5 символов
    double avgWordLength = 5.0;
    double charactersPerMinute = (double)wpm * avgWordLength;
    double charactersPerSecond = charactersPerMinute / 60.0;
    double intervalPerCharacter = 1.0 / charactersPerSecond;
    
    // Запускаем таймер
    self.typingTimer = [NSTimer scheduledTimerWithTimeInterval:intervalPerCharacter
                                                        target:self
                                                      selector:@selector(typeNextCharacter)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)stopTyping {
    [self.typingTimer invalidate];
    self.typingTimer = nil;
    self.isTyping = NO;
    self.currentIndex = 0;
}

- (void)typeNextCharacter {
    if (self.currentIndex >= self.textToType.length) {
        [self stopTyping];
        
        // Уведомление о завершении
        dispatch_async(dispatch_get_main_queue(), ^{
            UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
            [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
        });
        
        return;
    }
    
    // Получаем следующий символ
    unichar character = [self.textToType characterAtIndex:self.currentIndex];
    NSString *charString = [NSString stringWithFormat:@"%C", character];
    
    // Вводим символ через системную клавиатуру
    dispatch_async(dispatch_get_main_queue(), ^{
        UIKeyboardImpl *keyboard = [UIKeyboardImpl sharedInstance];
        if (keyboard) {
            [keyboard insertText:charString];
            
            // Callback для подсветки
            if (self.onCharacterTyped) {
                self.onCharacterTyped(charString);
            }
            
            // Легкая вибрация при каждом символе
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [generator impactOccurred];
        }
    });
    
    self.currentIndex++;
}

@end
