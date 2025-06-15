//
//  AppFeature.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 15.06.2025.
//

enum AppFeature: String, CaseIterable {
  case newUI = "new-ui-enabled"
  case experimentalAPI = "use-experimental-api"
  case canOpenDetails = "can-open-details"
}
