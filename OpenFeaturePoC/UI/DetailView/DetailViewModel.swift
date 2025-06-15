import Foundation

//
//  DetailViewModel.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 15.06.2025.
//

@MainActor
final class DetailViewModel: ObservableObject {
  private let flagService: FeatureFlagService

  init(flagService: FeatureFlagService) {
    self.flagService = flagService
  }

  var isNewUIEnabled: Bool {
    flagService.isNewUIEnabled
  }
}
