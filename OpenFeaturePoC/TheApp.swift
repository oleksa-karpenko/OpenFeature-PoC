//
//  TheApp.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 11.06.2025.
//

import SwiftUI

@main
struct TheApp: App {
  @Environment(\.scenePhase) private var scenePhase

  private var ffService = FeatureFlagService(
    provider: FlagsmithProvider(),
  )

  var body: some Scene {
    WindowGroup {
      ContentView(
        viewModel: ContentViewModel(flagService: ffService),
      )
      .environmentObject(ffService)
      .task {
        await ffService.evaluateFlags()
      }
    }
    .onChange(of: scenePhase) { _, new in
      switch new {
      case .active:
        print("🟢 App moved to foreground")
        Task { try await ffService.reload() }
      case .inactive:
        print("🔴 App is inactive")
      case .background:
        print("🔵 App moved to background")
      @unknown default:
        break
      }
    }
  }
}
