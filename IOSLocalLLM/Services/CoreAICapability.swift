import Foundation

/// Compile-time and runtime gates for the optional Core AI edition.
///
/// The default iOS 18+ build does not link `coreai-models` or CoreAI.framework.
/// Set the `CORE_AI` Swift compilation condition and add the package in an
/// iOS 27 target to build the Core AI edition.
enum CoreAICapability {
    #if CORE_AI
    static let isCompiledIn = true
    #else
    static let isCompiledIn = false
    #endif

    static var isRuntimeAvailable: Bool {
        guard isCompiledIn else { return false }
        if #available(iOS 27.0, *) { return true }
        return false
    }

    static let unavailableMessage =
        "Core AI requires iOS 27 and a Core AI-enabled build. Use an MLX or GGUF model instead."
}
