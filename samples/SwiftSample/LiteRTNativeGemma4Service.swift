import Foundation

final class LiteRTNativeGemma4Service {
    private let engine: LiteRTNativeGemma4Engine

    init(modelPath: String) throws {
        var createError: NSError?
        guard let engine = LiteRTNativeGemma4Engine(
            modelPath: modelPath,
            backend: .cpu,
            error: &createError
        ) else {
            throw createError ?? NSError(domain: "LiteRTNativeGemma4Service", code: 1)
        }

        var warmupError: NSError?
        guard engine.warmUp(&warmupError) else {
            throw warmupError ?? NSError(domain: "LiteRTNativeGemma4Service", code: 2)
        }

        self.engine = engine
    }

    func generate(prompt: String) throws -> String {
        var generationError: NSError?
        guard let text = engine.generateTextFromPrompt(prompt, error: &generationError) else {
            throw generationError ?? NSError(domain: "LiteRTNativeGemma4Service", code: 3)
        }
        return text
    }
}
