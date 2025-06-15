//
//  DetailView.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 13.06.2025.
//

import OpenFeature
import SwiftUI

struct DetailView: View {
  @EnvironmentObject var flagService: FeatureFlagService
  private var viewModel: DetailViewModel

  init(viewModel: DetailViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    VStack(spacing: 20) {
      if viewModel.isNewUIEnabled {
        Image("modern")
          .resizable()
          .foregroundColor(.blue)
        Text("🏡 You're seeing the new detail view!")
          .font(.title2)
          .foregroundColor(.blue)
      } else {
        Image("old")
          .resizable()
          .foregroundColor(.gray)
        Text("🏚️ This is the old detail view.")
          .font(.body)
          .foregroundColor(.gray)
      }
    }
    .padding()
    .navigationTitle("Details")
  }
}

#Preview {
  let ffService = FeatureFlagService(provider: MockFeatureProvider())
  let viewModel = DetailViewModel(flagService: ffService)
  DetailView(viewModel: viewModel)
}
