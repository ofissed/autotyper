#import <Foundation/Foundation.h>

@interface ATTypingManager : NSObject

@property (nonatomic, copy) void (^onCharacterTyped)(NSString *character);
@property (nonatomic, assign) BOOL isTyping;

+ (instancetype)sharedManager;
- (void)startTypingText:(NSString *)text withSpeed:(NSInteger)wpm;
- (void)stopTyping;

@end
