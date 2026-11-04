# Mahalli — diff from upstream OnDevice Core

Baseline: `Mesutcydev/ondevice-core` snapshot (upstream commit 6b145d5, 2026-10-01), imported unchanged as the first commit of this repo (`Import upstream ondevice-core (MIT) source snapshot`).
Counts are lines added / removed per file (`-` = binary). Every file not listed here is **byte-identical** to upstream.

Summary: 74 removed, 14 added, 114 modified, 8 renamed.

Removed = Lens/camera/OCR/Code-Mode sources and their test, upstream icons/screenshots/promo art, upstream CI workflows/CODEOWNERS/dependabot. Modified = Lens call-site cleanup, rebrand (ids/names/links), Sahl light theme tokens, fonts, Arabic (Saudi) strings. No engine/service logic was changed besides removing Lens hooks.

## Removed files (74)

| File | + | - |
|---|---|---|
| `.github/CODEOWNERS` | 0 | 10 |
| `.github/dependabot.yml` | 0 | 10 |
| `.github/workflows/dco.yml` | 0 | 21 |
| `.github/workflows/dependency-review.yml` | 0 | 16 |
| `.github/workflows/scorecard.yml` | 0 | 42 |
| `.github/workflows/source-release.yml` | 0 | 80 |
| `.github/workflows/validate.yml` | 0 | 25 |
| `Docs/Images/Screenshots/assistant.png` | - | - |
| `Docs/Images/Screenshots/home.png` | - | - |
| `Docs/Images/Screenshots/local-vision.png` | - | - |
| `Docs/Images/Screenshots/models.png` | - | - |
| `Docs/Images/ios-local-llm-spec-chart.png` | - | - |
| `Docs/Images/ios-local-llm-spec-chart.svg` | 0 | 222 |
| `Docs/Images/social-preview.png` | - | - |
| `Docs/VoiceOrbPreviews/01-idle.png` | - | - |
| `Docs/VoiceOrbPreviews/02-preparing.png` | - | - |
| `Docs/VoiceOrbPreviews/03-listening.png` | - | - |
| `Docs/VoiceOrbPreviews/04-thinking.png` | - | - |
| `Docs/VoiceOrbPreviews/05-speaking.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/AppIconClassic.appiconset/AppIconClassic-1024.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/AppIconClassic.appiconset/Contents.json` | 0 | 14 |
| `IOSLocalLLM/Assets.xcassets/AppIconClassicPreview.imageset/AppIconClassicPreview-256.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/AppIconClassicPreview.imageset/Contents.json` | 0 | 13 |
| `IOSLocalLLM/Assets.xcassets/image_studio_app_icon.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/image_studio_app_icon.imageset/image_studio_app_icon.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_assistant.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_assistant.imageset/img_assistant.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_generation.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_generation.imageset/img_generation.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_lens.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_lens.imageset/img_lens.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_mac_bridge.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_mac_bridge.imageset/img_mac_bridge.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_prompting.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_prompting.imageset/img_prompting.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_prompting_alt.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_prompting_alt.imageset/img_prompting_alt.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/img_voice.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/img_voice.imageset/img_voice.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/token_app_icon.imageset/Contents.json` | 0 | 21 |
| `IOSLocalLLM/Assets.xcassets/token_app_icon.imageset/token_app_icon.jpg` | - | - |
| `IOSLocalLLM/Models/Detection.swift` | 0 | 171 |
| `IOSLocalLLM/Models/LensPromptPreset.swift` | 0 | 99 |
| `IOSLocalLLM/Services/AnalysisService.swift` | 0 | 1227 |
| `IOSLocalLLM/Services/CameraService.swift` | 0 | 533 |
| `IOSLocalLLM/Services/CodeModeController.swift` | 0 | 207 |
| `IOSLocalLLM/Services/LensFramePreparer.swift` | 0 | 585 |
| `IOSLocalLLM/Services/LiveOCRService.swift` | 0 | 98 |
| `IOSLocalLLM/Services/OCRService.swift` | 0 | 117 |
| `IOSLocalLLM/Services/TextRegionDetector.swift` | 0 | 128 |
| `IOSLocalLLM/Services/Voice/LensVoiceNarrator.swift` | 0 | 209 |
| `IOSLocalLLM/Views/AnalysisHistoryView.swift` | 0 | 305 |
| `IOSLocalLLM/Views/AnalysisPanelView.swift` | 0 | 756 |
| `IOSLocalLLM/Views/CameraPreviewView.swift` | 0 | 52 |
| `IOSLocalLLM/Views/CodeModeView.swift` | 0 | 329 |
| `IOSLocalLLM/Views/CodePanelView.swift` | 0 | 299 |
| `IOSLocalLLM/Views/DocumentScannerView.swift` | 0 | 73 |
| `IOSLocalLLM/Views/LensDebugOverlay.swift` | 0 | 269 |
| `IOSLocalLLM/Views/LensPromptPresetSheet.swift` | 0 | 123 |
| `IOSLocalLLM/Views/LensTaskPanel.swift` | 0 | 511 |
| `IOSLocalLLM/Views/LiveOCROverlayView.swift` | 0 | 61 |
| `IOSLocalLLM/Views/MarkupCanvasView.swift` | 0 | 101 |
| `IOSLocalLLM/Views/OverlayView.swift` | 0 | 96 |
| `IOSLocalLLM/ss/1.PNG` | - | - |
| `IOSLocalLLM/ss/1840 a.PNG` | - | - |
| `IOSLocalLLM/ss/2.PNG` | - | - |
| `IOSLocalLLM/ss/3.PNG` | - | - |
| `IOSLocalLLM/ss/4.PNG` | - | - |
| `IOSLocalLLM/ss/6.PNG` | - | - |
| `IOSLocalLLM/ss/7.PNG` | - | - |
| `IOSLocalLLMTests/LensVoiceNarratorTests.swift` | 0 | 137 |
| `LENS_PIPELINE.md` | 0 | 254 |
| `OnDeviceCoreAIStudio.xcodeproj/project.pbxproj` | 0 | 3170 |
| `PHASE7_VISION.md` | 0 | 662 |

## Renamed files (8)

| File | + | - |
|---|---|---|
| `IOSLocalLLM/Services/VisionInferenceLoop.swift ← IOSLocalLLM/Services/LensInferenceLoop.swift` | 53 | 53 |
| `Mahalli.xcodeproj/project.xcworkspace/contents.xcworkspacedata ← OnDeviceCoreAIStudio.xcodeproj/project.xcworkspace/contents.xcworkspacedata` | 0 | 0 |
| `Mahalli.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved ← OnDeviceCoreAIStudio.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` | 0 | 0 |
| `Mahalli.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/configuration/mirrors.json ← OnDeviceCoreAIStudio.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/configuration/mirrors.json` | 0 | 0 |
| `Mahalli.xcodeproj/xcshareddata/xcschemes/Mahalli.xcscheme ← OnDeviceCoreAIStudio.xcodeproj/xcshareddata/xcschemes/OnDeviceCoreAIStudio.xcscheme` | 17 | 16 |
| `Mahalli.xcworkspace/contents.xcworkspacedata ← OnDeviceCoreAIStudio.xcworkspace/contents.xcworkspacedata` | 1 | 1 |
| `Mahalli.xcworkspace/xcshareddata/swiftpm/Package.resolved ← OnDeviceCoreAIStudio.xcworkspace/xcshareddata/swiftpm/Package.resolved` | 0 | 0 |
| `Mahalli.xcworkspace/xcshareddata/swiftpm/configuration/mirrors.json ← OnDeviceCoreAIStudio.xcworkspace/xcshareddata/swiftpm/configuration/mirrors.json` | 0 | 0 |

## Added files (14)

| File | + | - |
|---|---|---|
| `.github/workflows/build-ipa.yml` | 141 | 0 |
| `DIFF_FROM_UPSTREAM.md` | 237 | 0 |
| `IOSLocalLLM/Resources/Fonts/IBMPlexSansArabic-Bold.ttf` | - | - |
| `IOSLocalLLM/Resources/Fonts/IBMPlexSansArabic-Light.ttf` | - | - |
| `IOSLocalLLM/Resources/Fonts/IBMPlexSansArabic-Medium.ttf` | - | - |
| `IOSLocalLLM/Resources/Fonts/IBMPlexSansArabic-Regular.ttf` | - | - |
| `IOSLocalLLM/Resources/Fonts/IBMPlexSansArabic-SemiBold.ttf` | - | - |
| `IOSLocalLLM/Resources/Fonts/OFL.txt` | 93 | 0 |
| `IOSLocalLLM/Views/Design/SahlFonts.swift` | 27 | 0 |
| `IOSLocalLLM/Views/SharedTextViews.swift` | 141 | 0 |
| `Mahalli.xcodeproj/project.pbxproj` | 3046 | 0 |
| `NOTICE` | 29 | 0 |
| `ThirdParty/llama.cpp` | 1 | 0 |
| `ThirdParty/whisper.cpp` | 1 | 0 |

## Modified files (114)

| File | + | - |
|---|---|---|
| `Design/ModelsConcepts/ModelsConcepts.swift` | 6 | 6 |
| `Docs/LOCAL_LLM_FOUNDATION_HANDOFF.md` | 26 | 26 |
| `Docs/UI_PERFORMANCE_CODELENS_AUDIT_2026-09-05.md` | 1 | 1 |
| `IOSLocalLLM/Assets.xcassets/AccentColor.colorset/Contents.json` | 13 | 13 |
| `IOSLocalLLM/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/AppIconPreview.imageset/AppIconPreview-256.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/AppLogo.imageset/AppLogo.png` | - | - |
| `IOSLocalLLM/Assets.xcassets/LaunchBackground.colorset/Contents.json` | 4 | 2 |
| `IOSLocalLLM/Assets.xcassets/app_logo_small.imageset/app_logo_small.png` | - | - |
| `IOSLocalLLM/ContentView.swift` | 18 | 1807 |
| `IOSLocalLLM/IOSLocalLLM-Catalyst.entitlements` | 3 | 3 |
| `IOSLocalLLM/IOSLocalLLM-PCC.entitlements` | 2 | 2 |
| `IOSLocalLLM/IOSLocalLLM.entitlements` | 2 | 2 |
| `IOSLocalLLM/IOSLocalLLMApp.swift` | 5 | 0 |
| `IOSLocalLLM/Info.plist` | 16 | 8 |
| `IOSLocalLLM/LocalAIRuntimeFoundation/Public/LocalAIController.swift` | 2 | 2 |
| `IOSLocalLLM/LocalAIRuntimeFoundation/Runtime/RuntimeCapabilities.swift` | 2 | 2 |
| `IOSLocalLLM/Models/AppBridge.swift` | 11 | 14 |
| `IOSLocalLLM/Models/AppSettings.swift` | 5 | 30 |
| `IOSLocalLLM/Models/AssistantModelCatalog.swift` | 1 | 1 |
| `IOSLocalLLM/Models/CodeTask.swift` | 1 | 1 |
| `IOSLocalLLM/Models/KoduTheme.swift` | 45 | 31 |
| `IOSLocalLLM/Models/LegalDocuments.swift` | 15 | 15 |
| `IOSLocalLLM/Models/ModelCatalogTypes.swift` | 2 | 2 |
| `IOSLocalLLM/Models/StudioTextBlocks.swift` | 1 | 1 |
| `IOSLocalLLM/Models/VoiceProfile.swift` | 1 | 1 |
| `IOSLocalLLM/Services/BackgroundDownloadCoordinator.swift` | 2 | 2 |
| `IOSLocalLLM/Services/Bridge/BridgeIdentity.swift` | 2 | 2 |
| `IOSLocalLLM/Services/Bridge/BridgePairingStore.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Bridge/LocalAPIServer.swift` | 1 | 1 |
| `IOSLocalLLM/Services/BundledVLMInstaller.swift` | 3 | 3 |
| `IOSLocalLLM/Services/CloudSyncService.swift` | 1 | 1 |
| `IOSLocalLLM/Services/CodingAssistantService.swift` | 18 | 18 |
| `IOSLocalLLM/Services/CoreAIHFDownloadManager.swift` | 2 | 2 |
| `IOSLocalLLM/Services/CoreAIInferenceService.swift` | 1 | 1 |
| `IOSLocalLLM/Services/DeviceSafetyMonitor.swift` | 1 | 1 |
| `IOSLocalLLM/Services/DeviceTierAdvisor.swift` | 7 | 7 |
| `IOSLocalLLM/Services/Diagnostics/Diagnostics.swift` | 2 | 2 |
| `IOSLocalLLM/Services/Diagnostics/SystemSnapshot.swift` | 1 | 1 |
| `IOSLocalLLM/Services/FastVLM.swift` | 4 | 4 |
| `IOSLocalLLM/Services/FastVLMRepoAutoDiscovery.swift` | 2 | 2 |
| `IOSLocalLLM/Services/FastVLMService.swift` | 1 | 1 |
| `IOSLocalLLM/Services/HFModelDownloadManager.swift` | 3 | 3 |
| `IOSLocalLLM/Services/HFSearchService.swift` | 2 | 2 |
| `IOSLocalLLM/Services/HFTokenStore.swift` | 3 | 3 |
| `IOSLocalLLM/Services/Intents/IOSLocalLLMAppIntents.swift` | 9 | 32 |
| `IOSLocalLLM/Services/LifecycleController.swift` | 10 | 10 |
| `IOSLocalLLM/Services/LlamaCpp/IOSLocalLLM-Bridging-Header.h` | 1 | 1 |
| `IOSLocalLLM/Services/LlamaCpp/LlamaCppVLMService.swift` | 17 | 17 |
| `IOSLocalLLM/Services/LocalizationService.swift` | 96 | 34 |
| `IOSLocalLLM/Services/MLXGenerationGate.swift` | 1 | 1 |
| `IOSLocalLLM/Services/MLXVisionService.swift` | 26 | 26 |
| `IOSLocalLLM/Services/MemoryAdvisor.swift` | 6 | 6 |
| `IOSLocalLLM/Services/ModelDownloadCenter.swift` | 5 | 5 |
| `IOSLocalLLM/Services/ModelPrefetcher.swift` | 1 | 1 |
| `IOSLocalLLM/Services/ModelResidency.swift` | 9 | 9 |
| `IOSLocalLLM/Services/RecoveryState.swift` | 1 | 1 |
| `IOSLocalLLM/Services/ReviewPromptService.swift` | 2 | 2 |
| `IOSLocalLLM/Services/Runtime/RuntimeEngineFactory.swift` | 1 | 1 |
| `IOSLocalLLM/Services/SmolVLM2Rescue.swift` | 2 | 2 |
| `IOSLocalLLM/Services/SpotlightIndexer.swift` | 2 | 2 |
| `IOSLocalLLM/Services/VLMCapabilities.swift` | 11 | 11 |
| `IOSLocalLLM/Services/VisualModelInstallStatus.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Voice/Pipeline/AudioQueue.swift` | 3 | 3 |
| `IOSLocalLLM/Services/Voice/Pipeline/ReasoningStripper.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Voice/Pipeline/SemanticChunker.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Voice/VoicePerformanceSignposts.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Voice/VoiceProfileRegistry.swift` | 6 | 6 |
| `IOSLocalLLM/Services/Voice/VoiceRuntimeDiagnostics.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Voice/VoiceService.swift` | 2 | 2 |
| `IOSLocalLLM/Services/Web/KeychainStore.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Web/WebPageFetchService.swift` | 1 | 1 |
| `IOSLocalLLM/Services/Web/WebSearchService.swift` | 1 | 1 |
| `IOSLocalLLM/Views/AppDesignSystem.swift` | 10 | 23 |
| `IOSLocalLLM/Views/Bridge/ArgentRemoteView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/Bridge/BridgePairingView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/CodingAssistantView.swift` | 8 | 8 |
| `IOSLocalLLM/Views/DiagnosticsView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/HFTokenSheet.swift` | 1 | 1 |
| `IOSLocalLLM/Views/HomeView.swift` | 3 | 5 |
| `IOSLocalLLM/Views/KoduComponents.swift` | 1 | 1 |
| `IOSLocalLLM/Views/Legal/AttributionsView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/Legal/LegalAcceptanceView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/MicDictationButton.swift` | 1 | 1 |
| `IOSLocalLLM/Views/ModelsManagerView.swift` | 13 | 13 |
| `IOSLocalLLM/Views/OnboardingModelPickerView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/OnboardingView.swift` | 2 | 2 |
| `IOSLocalLLM/Views/SettingsView.swift` | 11 | 46 |
| `IOSLocalLLM/Views/SetupBannerView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/UnsupportedDeviceView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/UserGuideView.swift` | 1 | 27 |
| `IOSLocalLLM/Views/VisualModelComparisonView.swift` | 1 | 1 |
| `IOSLocalLLM/Views/VisualModelPickerView.swift` | 12 | 12 |
| `IOSLocalLLM/Views/Voice/VoiceSettingsView.swift` | 2 | 18 |
| `IOSLocalLLM/Views/Voice/VoiceStatusPill.swift` | 5 | 5 |
| `IOSLocalLLMShareExtension/IOSLocalLLMShareExtension.entitlements` | 1 | 1 |
| `IOSLocalLLMShareExtension/Info.plist` | 1 | 1 |
| `IOSLocalLLMShareExtension/ShareViewController.swift` | 9 | 9 |
| `IOSLocalLLMTests/DeviceTierAdvisorTests.swift` | 7 | 7 |
| `IOSLocalLLMTests/SemanticChunkerTests.swift` | 1 | 1 |
| `LICENSE` | 1 | 0 |
| `Podfile` | 1 | 1 |
| `README.md` | 11 | 0 |
| `project-simcompat.yml` | 23 | 23 |
| `project.yml` | 30 | 24 |
| `scripts/build_sideload_ipa.sh` | 15 | 15 |
| `scripts/collect_sideload_notices.py` | 1 | 1 |
| `scripts/download_voice_models.sh` | 1 | 1 |
| `scripts/package_adhoc_sideloadable_ipa.sh` | 1 | 1 |
| `scripts/package_background_assets.sh` | 1 | 1 |
| `scripts/package_sideloadable_ipa.sh` | 1 | 1 |
| `scripts/patch-mlx-disable-nax.sh` | 1 | 1 |
| `scripts/validate_open_source.sh` | 2 | 2 |
| `scripts/verify_ipa_identity.sh` | 1 | 1 |
