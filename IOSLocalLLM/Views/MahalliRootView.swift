// Copyright (c) 2026 justmgz
// SPDX-License-Identifier: MIT
//
// Root navigation shell for Mahalli (محلّي).
//
// Five bottom tabs (Home · Chat · Voice · Models · Local API), RTL-aware,
// on the flat light "Sahl" design system. Settings, the Mac bridge and the
// image studio open as sheets from Home. Tab switching requested elsewhere
// in the app (App Intents, share extension, deep links) arrives through
// `AppBridge.requestedTab` and is mapped here.

import SwiftUI

enum MahalliTab: Int, Hashable {
    case home = 0
    case chat = 1
    case models = 2
    case voice = 4
    case localAPI = 5
}

struct MahalliRootView: View {
    @Environment(\.koduTheme) private var T
    @ObservedObject private var bridge = AppBridge.shared
    @ObservedObject private var loc = LocalizationService.shared

    @State private var selection: MahalliTab = .home
    @State private var showingSettings = false
    @State private var showingMac = false
    @State private var showingImageStudio = false

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack {
                HomeView(
                    onNewChat: {
                        AppBridge.shared.startNewChat()
                        selection = .chat
                    },
                    onOpenVoice: { selection = .voice },
                    onOpenModels: { selection = .models },
                    onOpenMac: { showingMac = true },
                    onGenerateImage: { showingImageStudio = true },
                    onOpenSettings: { showingSettings = true },
                    onOpenConversation: { convo in
                        AppBridge.shared.openConversation(id: convo.id)
                        selection = .chat
                    }
                )
            }
            .tabItem { Label(loc.t("Home"), systemImage: "house") }
            .tag(MahalliTab.home)

            CodingAssistantView(isActive: selection == .chat)
                .tabItem { Label(loc.t("Chat"), systemImage: "bubble.left.and.bubble.right") }
                .tag(MahalliTab.chat)

            VoiceConversationView()
                .tabItem { Label(loc.t("voice"), systemImage: "waveform") }
                .tag(MahalliTab.voice)

            ModelsManagerView(isActive: selection == .models)
                .tabItem { Label(loc.t("models"), systemImage: "square.stack.3d.up") }
                .tag(MahalliTab.models)

            LocalAPIServerView()
                .tabItem { Label(loc.t("Local API"), systemImage: "antenna.radiowaves.left.and.right") }
                .tag(MahalliTab.localAPI)
        }
        .tint(T.accent)
        .onAppear { applyRequestedTab(bridge.requestedTab) }
        .onChange(of: bridge.requestedTab) { _, newValue in
            applyRequestedTab(newValue)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(assistant: CodingAssistantService.shared)
                .lasTheme()
        }
        .sheet(isPresented: $showingMac) {
            BridgePairingView()
                .lasTheme()
        }
        .sheet(isPresented: $showingImageStudio) {
            ImageGenerationView()
                .lasTheme()
        }
    }

    private func applyRequestedTab(_ raw: Int?) {
        guard let raw else { return }
        defer { bridge.requestedTab = nil }
        switch raw {
        case AppBridge.Tab.home.rawValue:      selection = .home
        case AppBridge.Tab.assistant.rawValue: selection = .chat
        case AppBridge.Tab.models.rawValue:    selection = .models
        case AppBridge.Tab.voice.rawValue:     selection = .voice
        case AppBridge.Tab.mac.rawValue:       showingMac = true
        default:                               break
        }
    }
}
