// Copyright (c) 2026 justmgz
// SPDX-License-Identifier: MIT
//
// Mahalli (محلّي) — app entry point. Derived from the MIT-licensed
// ios-local-llm project; see NOTICE.

import SwiftUI
import UIKit

@main
struct MahalliApp: App {
    @UIApplicationDelegateAdaptor(MahalliAppDelegate.self) private var appDelegate
    @ObservedObject private var settings = AppSettings.shared
    @Environment(\.scenePhase) private var scenePhase

    init() {
        // Fonts are declared in Info.plist (UIAppFonts); this is a fallback.
        SahlFonts.registerBundledFonts()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                SahlBackdrop()

                Group {
                    if settings.hasSeenOnboarding {
                        MahalliRootView()
                            .transition(.opacity)
                    } else {
                        OnboardingView()
                            .transition(.opacity)
                    }
                }
            }
            .lasTheme()
            .onOpenURL { url in
                AppBridge.shared.handleIncomingURL(url)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            LifecycleController.shared.handle(phase: newPhase)
        }
    }
}

final class MahalliAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        CrashReporter.shared.install()
        Diagnostics.shared.breadcrumb("Mahalli launch", category: "lifecycle")
        return true
    }

    func application(
        _ application: UIApplication,
        handleEventsForBackgroundURLSession identifier: String,
        completionHandler: @escaping () -> Void
    ) {
        guard identifier == BackgroundDownloadCoordinator.sessionIdentifier else {
            completionHandler()
            return
        }
        RuntimeLogCenter.emit(
            "Reattaching background model-download session",
            subsystem: "download"
        )
        Task { @MainActor in
            let coordinator = BackgroundDownloadCoordinator.shared
            coordinator.systemCompletionHandler = completionHandler
            coordinator.reattach()
        }
    }
}
