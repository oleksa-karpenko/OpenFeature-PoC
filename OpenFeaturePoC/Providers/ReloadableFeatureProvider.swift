//
//  ReloadableFeatureProvider.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 15.06.2025.
//

import OpenFeature

protocol FetchableFeatureProvider: FeatureProvider {
  func fetchFlags() async throws
}
