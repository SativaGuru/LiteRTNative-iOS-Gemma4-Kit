#import <Foundation/Foundation.h>
#import "LiteRTNativeGemma4/LiteRTNativeGemma4.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        if (argc < 2) {
            NSLog(@"Usage: LiteRTNativeGemma4Example <path-to-model.litertlm>");
            return 1;
        }

        NSString *modelPath = [NSString stringWithUTF8String:argv[1]];
        NSError *error = nil;
        LiteRTNativeGemma4Engine *engine =
            [[LiteRTNativeGemma4Engine alloc] initWithModelPath:modelPath
                                                        backend:LiteRTNativeGemma4BackendCPU
                                                          error:&error];
        if (engine == nil) {
            NSLog(@"Create failed: %@", error);
            return 2;
        }

        if (![engine warmUp:&error]) {
            NSLog(@"Warm-up failed: %@", error);
            return 3;
        }

        NSString *text = [engine generateTextFromPrompt:@"Say hello from Gemma 4 running through LiteRT-LM."
                                                  error:&error];
        if (text == nil) {
            NSLog(@"Generation failed: %@", error);
            return 4;
        }

        NSLog(@"%@", text);
        return 0;
    }
}
