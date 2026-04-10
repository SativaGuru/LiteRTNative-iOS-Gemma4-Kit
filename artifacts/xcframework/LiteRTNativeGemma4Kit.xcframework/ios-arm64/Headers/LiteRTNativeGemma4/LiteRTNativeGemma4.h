#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LiteRTNativeGemma4Backend) {
    LiteRTNativeGemma4BackendCPU = 0,
    LiteRTNativeGemma4BackendGPU = 1,
} NS_SWIFT_NAME(LiteRTNativeGemma4Engine.Backend);

FOUNDATION_EXPORT NSErrorDomain const LiteRTNativeGemma4ErrorDomain;

NS_SWIFT_NAME(LiteRTNativeGemma4Engine)
@interface LiteRTNativeGemma4Engine : NSObject

@property (nonatomic, copy, readonly) NSString *modelPath;
@property (nonatomic, assign, readonly) LiteRTNativeGemma4Backend backend;

- (nullable instancetype)initWithModelPath:(NSString *)modelPath
                                   backend:(LiteRTNativeGemma4Backend)backend
                                     error:(NSError * _Nullable * _Nullable)error NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (BOOL)warmUp:(NSError * _Nullable * _Nullable)error;

- (nullable NSString *)generateTextFromPrompt:(NSString *)prompt
                                        error:(NSError * _Nullable * _Nullable)error;

- (nullable NSString *)generateRawJSONFromPrompt:(NSString *)prompt
                                           error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END

