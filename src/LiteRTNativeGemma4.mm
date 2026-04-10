#import "LiteRTNativeGemma4/LiteRTNativeGemma4.h"

#include <litert_lm/engine.h>

NSErrorDomain const LiteRTNativeGemma4ErrorDomain = @"LiteRTNativeGemma4ErrorDomain";

namespace {

static NSString *LiteRTNativeTrimmedString(NSString *value) {
    return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

static NSError *LiteRTNativeError(NSInteger code, NSString *description) {
    return [NSError errorWithDomain:LiteRTNativeGemma4ErrorDomain
                               code:code
                           userInfo:@{NSLocalizedDescriptionKey: description}];
}

static void LiteRTNativeAssignError(NSError **error, NSInteger code, NSString *description) {
    if (error != nil) {
        *error = LiteRTNativeError(code, description);
    }
}

static NSString *LiteRTNativeBackendString(LiteRTNativeGemma4Backend backend) {
    switch (backend) {
        case LiteRTNativeGemma4BackendCPU:
            return @"cpu";
        case LiteRTNativeGemma4BackendGPU:
            return @"gpu";
    }
    return @"cpu";
}

static NSString *LiteRTNativeExtractTextFromJSONResponse(const char *responseJSON) {
    if (responseJSON == nullptr || responseJSON[0] == '\0') {
        return nil;
    }

    NSString *rawString = [NSString stringWithUTF8String:responseJSON];
    if (rawString == nil || rawString.length == 0) {
        return nil;
    }

    NSData *responseData = [rawString dataUsingEncoding:NSUTF8StringEncoding];
    if (responseData == nil) {
        return rawString;
    }

    NSError *parseError = nil;
    id parsedObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
    if (parseError != nil || ![parsedObject isKindOfClass:[NSDictionary class]]) {
        return rawString;
    }

    NSMutableArray<NSString *> *textParts = [NSMutableArray array];
    void (^appendTextItems)(id) = ^(id contentValue) {
        if (![contentValue isKindOfClass:[NSArray class]]) {
            return;
        }
        for (id item in (NSArray *)contentValue) {
            if (![item isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            NSDictionary *dictionary = (NSDictionary *)item;
            id typeValue = dictionary[@"type"];
            id textValue = dictionary[@"text"];
            if ([typeValue isKindOfClass:[NSString class]] &&
                [textValue isKindOfClass:[NSString class]] &&
                [((NSString *)typeValue) isEqualToString:@"text"] &&
                ((NSString *)textValue).length > 0) {
                [textParts addObject:(NSString *)textValue];
            }
        }
    };

    NSDictionary *root = (NSDictionary *)parsedObject;
    appendTextItems(root[@"content"]);

    if (textParts.count == 0) {
        id candidatesValue = root[@"candidates"];
        if ([candidatesValue isKindOfClass:[NSArray class]]) {
            for (id candidate in (NSArray *)candidatesValue) {
                if (![candidate isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                appendTextItems(((NSDictionary *)candidate)[@"content"]);
            }
        }
    }

    if (textParts.count > 0) {
        return [textParts componentsJoinedByString:@"\n"];
    }

    id topLevelText = root[@"text"];
    if ([topLevelText isKindOfClass:[NSString class]] && ((NSString *)topLevelText).length > 0) {
        return (NSString *)topLevelText;
    }

    return rawString;
}

static NSString *LiteRTNativeBuildMessageJSON(NSString *prompt, NSError **error) {
    NSDictionary *payload = @{
        @"role": @"user",
        @"content": @[
            @{
                @"type": @"text",
                @"text": prompt
            }
        ]
    };

    NSError *serializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&serializationError];
    if (data == nil) {
        LiteRTNativeAssignError(error,
                                7,
                                serializationError.localizedDescription ?: @"Failed to build LiteRT-LM input JSON.");
        return nil;
    }

    NSString *messageJSON = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (messageJSON.length == 0) {
        LiteRTNativeAssignError(error, 8, @"LiteRT-LM input JSON encoding produced an empty string.");
        return nil;
    }
    return messageJSON;
}

}  // namespace

@interface LiteRTNativeGemma4Engine () {
    LiteRtLmEngine *_engine;
    LiteRtLmSessionConfig *_sessionConfig;
    LiteRtLmConversationConfig *_conversationConfig;
    LiteRtLmConversation *_conversation;
}

@property (nonatomic, copy, readwrite) NSString *modelPath;
@property (nonatomic, assign, readwrite) LiteRTNativeGemma4Backend backend;

@end

@implementation LiteRTNativeGemma4Engine

- (nullable instancetype)initWithModelPath:(NSString *)modelPath
                                   backend:(LiteRTNativeGemma4Backend)backend
                                     error:(NSError * _Nullable __autoreleasing *)error {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    NSString *trimmedPath = LiteRTNativeTrimmedString(modelPath);
    if (trimmedPath.length == 0) {
        LiteRTNativeAssignError(error, 1, @"Model path must not be empty.");
        return nil;
    }

    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:trimmedPath isDirectory:&isDirectory] || isDirectory) {
        LiteRTNativeAssignError(error, 2, [NSString stringWithFormat:@"Model path does not point to a file: %@", trimmedPath]);
        return nil;
    }

    self.modelPath = trimmedPath;
    self.backend = backend;

    litert_lm_set_min_log_level(0);

    NSString *backendString = LiteRTNativeBackendString(backend);
    LiteRtLmEngineSettings *engineSettings =
        litert_lm_engine_settings_create(trimmedPath.UTF8String, backendString.UTF8String, nullptr, nullptr);
    if (engineSettings == nullptr) {
        LiteRTNativeAssignError(error,
                                3,
                                [NSString stringWithFormat:@"Failed to create LiteRT-LM engine settings for backend=%@.", backendString]);
        return nil;
    }

    _engine = litert_lm_engine_create(engineSettings);
    litert_lm_engine_settings_delete(engineSettings);
    if (_engine == nullptr) {
        LiteRTNativeAssignError(error,
                                4,
                                [NSString stringWithFormat:@"Failed to create LiteRT-LM engine for backend=%@.", backendString]);
        return nil;
    }

    _sessionConfig = litert_lm_session_config_create();
    if (_sessionConfig == nullptr) {
        LiteRTNativeAssignError(error, 5, @"Failed to create LiteRT-LM session config.");
        return nil;
    }

    LiteRtLmSamplerParams samplerParams{};
    samplerParams.type = kTopP;
    samplerParams.top_k = 64;
    samplerParams.top_p = 0.95f;
    samplerParams.temperature = 1.0f;
    samplerParams.seed = 0;
    litert_lm_session_config_set_sampler_params(_sessionConfig, &samplerParams);

    _conversationConfig = litert_lm_conversation_config_create(
        _engine,
        _sessionConfig,
        nullptr,
        nullptr,
        nullptr,
        false);
    if (_conversationConfig == nullptr) {
        LiteRTNativeAssignError(error, 6, @"Failed to create LiteRT-LM conversation config.");
        return nil;
    }

    _conversation = litert_lm_conversation_create(_engine, _conversationConfig);
    if (_conversation == nullptr) {
        LiteRTNativeAssignError(error, 9, @"Failed to create LiteRT-LM conversation.");
        return nil;
    }

    return self;
}

- (void)dealloc {
    if (_conversation != nullptr) {
        litert_lm_conversation_delete(_conversation);
        _conversation = nullptr;
    }
    if (_conversationConfig != nullptr) {
        litert_lm_conversation_config_delete(_conversationConfig);
        _conversationConfig = nullptr;
    }
    if (_sessionConfig != nullptr) {
        litert_lm_session_config_delete(_sessionConfig);
        _sessionConfig = nullptr;
    }
    if (_engine != nullptr) {
        litert_lm_engine_delete(_engine);
        _engine = nullptr;
    }
}

- (BOOL)warmUp:(NSError * _Nullable __autoreleasing *)error {
    if (_conversation == nullptr) {
        LiteRTNativeAssignError(error, 10, @"LiteRT-LM conversation is not initialized.");
        return NO;
    }
    return YES;
}

- (nullable NSString *)generateRawJSONFromPrompt:(NSString *)prompt
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSString *trimmedPrompt = LiteRTNativeTrimmedString(prompt);
    if (trimmedPrompt.length == 0) {
        LiteRTNativeAssignError(error, 11, @"Prompt must not be empty.");
        return nil;
    }

    if (_conversation == nullptr) {
        LiteRTNativeAssignError(error, 12, @"LiteRT-LM conversation is not initialized.");
        return nil;
    }

    NSString *messageJSON = LiteRTNativeBuildMessageJSON(trimmedPrompt, error);
    if (messageJSON == nil) {
        return nil;
    }

    LiteRtLmJsonResponse *response =
        litert_lm_conversation_send_message(_conversation, messageJSON.UTF8String, nullptr);
    if (response == nullptr) {
        LiteRTNativeAssignError(error, 13, @"LiteRT-LM conversation returned a null response.");
        return nil;
    }

    const char *responseCString = litert_lm_json_response_get_string(response);
    NSString *rawResponse = responseCString != nullptr ? [NSString stringWithUTF8String:responseCString] : nil;
    litert_lm_json_response_delete(response);

    if (rawResponse.length == 0) {
        LiteRTNativeAssignError(error, 14, @"LiteRT-LM returned an empty JSON response.");
        return nil;
    }

    return rawResponse;
}

- (nullable NSString *)generateTextFromPrompt:(NSString *)prompt
                                        error:(NSError * _Nullable __autoreleasing *)error {
    NSString *rawJSON = [self generateRawJSONFromPrompt:prompt error:error];
    if (rawJSON.length == 0) {
        return nil;
    }

    NSString *text = LiteRTNativeExtractTextFromJSONResponse(rawJSON.UTF8String);
    if (text.length == 0) {
        LiteRTNativeAssignError(error, 15, @"LiteRT-LM returned JSON, but no text content could be extracted.");
        return nil;
    }
    return text;
}

@end

