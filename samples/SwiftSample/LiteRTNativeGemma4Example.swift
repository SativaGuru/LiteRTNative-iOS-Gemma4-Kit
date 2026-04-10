import Foundation

enum LiteRTNativeGemma4ExampleError: Error {
    case create(NSError?)
    case warmUp(NSError?)
    case generate(NSError?)
}

final class LiteRTNativeGemma4Example {
    func run(modelPath: String, prompt: String) throws -> String {
        var createError: NSError?
        guard let engine = LiteRTNativeGemma4Engine(
            modelPath: modelPath,
            backend: .cpu,
            error: &createError
        ) else {
            throw LiteRTNativeGemma4ExampleError.create(createError)
        }

        var warmUpError: NSError?
        guard engine.warmUp(&warmUpError) else {
            throw LiteRTNativeGemma4ExampleError.warmUp(warmUpError)
        }

        var generationError: NSError?
        guard let text = engine.generateTextFromPrompt(prompt, error: &generationError) else {
            throw LiteRTNativeGemma4ExampleError.generate(generationError)
        }

        return text
    }
}
