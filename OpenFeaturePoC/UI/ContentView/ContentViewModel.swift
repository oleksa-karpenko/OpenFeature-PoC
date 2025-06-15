//
//  ContentViewModel.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 15.06.2025.
//

import Combine
import Foundation

@MainActor
final class ContentViewModel: ObservableObject {
  @Published var featureFlags: [(String, Bool)] = []
  @Published var canOpenDetails: Bool = false
  private var cancellables = Set<AnyCancellable>()
  private let flagService: FeatureFlagService

  init(flagService: FeatureFlagService) {
    self.flagService = flagService
    bind()
  }

  private func bind() {
    flagService.$allFlags
      .map { $0.sorted(by: { $0.key < $1.key }) }
      .receive(on: DispatchQueue.main)
      .assign(to: &$featureFlags)
    flagService.$canOpenDetails.assign(to: &$canOpenDetails)

    printFlags()
  }

  func printFlags() {
    print("# ContentViewModel: featureFlags:")
    for (key, value) in featureFlags {
      print("🔹 \(key): \(value)")
    }
  }

  func reload() async {
    try? await flagService.reload()
    bind()
  }
}
