//
//  ContentView.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 11.06.2025.
//

import OpenFeature
import SwiftUI

struct ContentView: View {
  @EnvironmentObject private var flagService: FeatureFlagService
  @State private var showDetail = false
  @ObservedObject private var viewModel: ContentViewModel

  init(viewModel: ContentViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Available Feature Flags")) {
          ForEach(viewModel.featureFlags, id: \.0) { key, value in
            HStack {
              Text(key)
              Spacer()
              Text(value.description)
                .foregroundColor(value ? .green : .red)
            }
          }
        }
        Section(header: Text("Actions")) {
          if viewModel.canOpenDetails {
            NavigationLink(destination: DetailView(viewModel: DetailViewModel(flagService: flagService))) {
              Text("Go to Detail View")
                .font(.body)
                .foregroundColor(.blue)
            }
          }
          Button("Reload Flags") {
            Task {
              await viewModel.reload()
            }
          }
        }
      }
      .navigationTitle("Feature Flags")
    }
  }
}

#Preview {
  let ffService = FeatureFlagService(provider: FlagsmithProvider())
  let viewModel = ContentViewModel(flagService: ffService)
  ContentView(viewModel: viewModel)
    .environmentObject(ffService)
}
