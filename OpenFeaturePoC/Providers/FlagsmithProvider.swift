//
//  FlagsmithProvider.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 13.06.2025.
//

import Combine
import Foundation
import OpenFeature

class FlagsmithProviderMetadata: ProviderMetadata {
  var name: String? { return "FlagsmithProvider" }
}

final class FlagsmithProvider: FetchableFeatureProvider {
  var metadata: ProviderMetadata = FlagsmithProviderMetadata()
  var hooks: [any Hook] = []
  private let environmentKey: String
  private let baseURL: String
  private var latestFlags: [String: Bool] = [:]
  private let subject = PassthroughSubject<ProviderEvent?, Never>()

  init(
    baseURL: String = "https://api.flagsmith.com/api/v1/flags/"
  ) {
    // let secretKey = Bundle.main.object(forInfoDictionaryKey: "FLAGSMITH_ENVIRONMENT_KEY") as? String ?? ""
    let secretKey = Bundle.main.infoDictionary?["FLAGSMITH_ENVIRONMENT_KEY"] as? String ?? ""
    environmentKey = secretKey
    self.baseURL = baseURL
  }

  func initialize(initialContext: EvaluationContext?) async throws {
    try await fetchFlags()
  }

  func onContextSet(oldContext: EvaluationContext?, newContext: EvaluationContext) async throws {
    // Optional: fetch user-specific flags if identity is provided
    try await fetchFlags()
  }

  func observe() -> AnyPublisher<ProviderEvent?, Never> {
    subject.eraseToAnyPublisher()
  }

  func getBooleanEvaluation(
    key: String,
    defaultValue: Bool,
    context: EvaluationContext?
  ) throws -> ProviderEvaluation<Bool> {
    let flagValue = latestFlags[key] ?? defaultValue
    return ProviderEvaluation(value: flagValue)
  }

  func getStringEvaluation(key: String, defaultValue: String, context: EvaluationContext?) throws -> ProviderEvaluation<String> {
    return ProviderEvaluation(value: defaultValue)
  }

  func getIntegerEvaluation(key: String, defaultValue: Int64, context: EvaluationContext?) throws -> ProviderEvaluation<Int64> {
    return ProviderEvaluation(value: defaultValue)
  }

  func getDoubleEvaluation(key: String, defaultValue: Double, context: EvaluationContext?) throws -> ProviderEvaluation<Double> {
    return ProviderEvaluation(value: defaultValue)
  }

  func getObjectEvaluation(key: String, defaultValue: Value, context: EvaluationContext?) throws -> ProviderEvaluation<Value> {
    return ProviderEvaluation(value: defaultValue)
  }

  public func fetchFlags() async throws {
    guard let url = URL(string: baseURL) else { return }

    var request = URLRequest(url: url)
    request.addValue(environmentKey, forHTTPHeaderField: "X-Environment-Key")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200
    else {
      throw URLError(.badServerResponse)
    }

    let decoded = try JSONDecoder().decode([FlagsmithFlag].self, from: data)

    // Update the local cache
    var newFlags: [String: Bool] = [:]
    for flag in decoded {
      newFlags[flag.feature.name] = flag.enabled
    }

    latestFlags = newFlags
    print("# Reload Flags:")
    printFlags()
    subject.send(.ready)
  }

  func printFlags() {
    print("📦 Current Flags:")
    for (key, value) in latestFlags {
      print("🔹 \(key): \(value)")
    }
  }
}

struct FlagsmithFlag: Decodable {
  struct Feature: Decodable {
    let name: String
  }

  let feature: Feature
  let enabled: Bool
}
