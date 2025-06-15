//
//  FeatureFlagService.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 11.06.2025.
//

import Foundation
import OpenFeature

typealias FeatureFlags = [String: Bool]

@MainActor
class FeatureFlagService: ObservableObject {
  @Published var allFlags: FeatureFlags = [:]

  @Published var isNewUIEnabled: Bool = false
  @Published var useExperimentalAPI: Bool = false
  @Published var canOpenDetails: Bool = false

  private let provider: FetchableFeatureProvider

  init(provider: FetchableFeatureProvider) {
    self.provider = provider
    OpenFeatureAPI.shared.setProvider(provider: provider)
    print("# FeatureFlagService: Initialized")
  }

  public func reload() async throws {
    try await provider.fetchFlags()
    await evaluateFlags()
    print("# FeatureFlagService: Feature flags reloaded")
  }

  private func update(flags: FeatureFlags) {
    allFlags = flags
    for key in AppFeature.allCases {
      let value = flags[key.rawValue] ?? false
      switch key {
      case .newUI: isNewUIEnabled = value
      case .experimentalAPI: useExperimentalAPI = value
      case .canOpenDetails: canOpenDetails = value
      }
    }

    print("# FeatureFlagService: Feature flags updated")
  }

  nonisolated
  func evaluateFlags() async {
    let client = OpenFeatureAPI.shared.getClient()
    var updated: [String: Bool] = [:]
    for key in AppFeature.allCases {
      let value = client.getBooleanValue(
        key: key.rawValue,
        defaultValue: false,
      )
      updated[key.rawValue] = value
    }
    await update(flags: updated)
    print("# FeatureFlagService: Feature flags evaluated")
  }
}
