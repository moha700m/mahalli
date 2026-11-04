#if !CORE_AI
import Foundation

// The iOS 18+ default build compiles the Core AI runtime out. This facade keeps
// the rest of the app source-compatible while every Core AI entry point fails
// closed with a clear message instead of linking CoreAI.framework (which does
// not exist before iOS 27).
enum CoreAIInferenceError: LocalizedError, Equatable {
    case unavailable(String)
    case modelMissing
    case unsupportedCapability(String)
    case invalidImage(String)
    case generationFailed
    case emptyConversation

    var errorDescription: String? {
        switch self {
        case .unavailable(let message): return message
        case .modelMissing: return "Download a Core AI pack from the Models tab first."
        case .unsupportedCapability(let capability): return "The selected Core AI model does not support \(capability)."
        case .invalidImage(let message): return message
        case .generationFailed: return "Core AI could not complete the local generation."
        case .emptyConversation: return "The request has no user message for Core AI to answer."
        }
    }
}

@MainActor
final class CoreAIInferenceService {
    static let shared = CoreAIInferenceService()

    private(set) var isReady = false
    private(set) var loadedSelectionID: String?

    private init() {}

    func isLoaded(as selectionID: String) -> Bool { false }

    nonisolated static func normalizedSelectionID(_ id: String) -> String {
        id.hasPrefix("coreai:") ? id : "coreai:\(id)"
    }

    nonisolated static func isCurrentRuntime(
        loadedID: String?,
        ready: Bool,
        requestedID: String
    ) -> Bool { false }

    func load() async throws {
        throw CoreAIInferenceError.unavailable(
            "Core AI is not included in this iOS 18 build. Select an MLX or GGUF model instead."
        )
    }

    func generate(
        messages: [ChatMessage],
        maxTokens: Int,
        temperature: Double,
        thinkingEnabled: Bool?,
        onToken: @escaping @Sendable (String) -> Void
    ) async throws {
        throw CoreAIInferenceError.unavailable(
            "Core AI is not included in this iOS 18 build. Select an MLX or GGUF model instead."
        )
    }

    func cancel() {}
    func unload() async {}
}
#endif
