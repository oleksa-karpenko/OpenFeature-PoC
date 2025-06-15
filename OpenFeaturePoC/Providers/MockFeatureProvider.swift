//
//  MockFeatureProvider.swift
//  OpenFeaturePoC
//
//  Created by Oleksandr Karpenko on 11.06.2025.
//

import Combine
import Foundation
import OpenFeature

class MockProviderMetadata: ProviderMetadata {
  var name: String? { return "MockFeatureProvider" }
}

final class MockFeatureProvider: FetchableFeatureProvider {
  func fetchFlags() async throws {
    // do nothing since Mock
  }

  func observe() -> AnyPublisher<OpenFeature.ProviderEvent?, Never> {
    // Since this is a mock, we’ll use a PassthroughSubject that never emits anything by default
    return Just(nil)
      .eraseToAnyPublisher()
  }

  // MARK: - Internal storage

  private var boolFlags: [String: Bool] = [
    "new-ui-enabled": true,
    "use-experimental-api": false,
  ]
  private var stringFlags: [String: String] = [:]
  private var intFlags: [String: Int64] = [:]
  private var doubleFlags: [String: Double] = [:]
  private var objectFlags: [String: Value] = [:]

  // MARK: - FeatureProvider metadata

  var hooks: [any Hook] = []

  let metadata: ProviderMetadata = MockProviderMetadata()

  // MARK: - Initialization

  func initialize(initialContext: EvaluationContext?) async throws {
    // No-op for mock
  }

  func onContextSet(oldContext: EvaluationContext?, newContext: EvaluationContext) async throws {
    // No-op for mock
  }

  // MARK: - Boolean flag evaluation

  func getBooleanEvaluation(
    key: String,
    defaultValue: Bool,
    context: EvaluationContext?
  ) throws -> ProviderEvaluation<Bool> {
    let value = boolFlags[key] ?? defaultValue
    return ProviderEvaluation(value: value)
  }

  func getStringEvaluation(
    key: String,
    defaultValue: String,
    context: EvaluationContext?
  ) throws -> ProviderEvaluation<String> {
    let value = stringFlags[key] ?? defaultValue
    return ProviderEvaluation(value: value)
  }

  func getIntegerEvaluation(key: String, defaultValue: Int64, context: EvaluationContext?) throws -> ProviderEvaluation<Int64> {
    let value = intFlags[key] ?? defaultValue
    return ProviderEvaluation(value: value)
  }

  func getDoubleEvaluation(key: String, defaultValue: Double, context: EvaluationContext?) throws -> ProviderEvaluation<Double> {
    let value = doubleFlags[key] ?? defaultValue
    return ProviderEvaluation(value: value)
  }

  func getObjectEvaluation(key: String, defaultValue: Value, context: EvaluationContext?) throws -> ProviderEvaluation<Value> {
    let value = objectFlags[key] ?? defaultValue
    return ProviderEvaluation(value: value)
  }

  // MARK: - Optional: Runtime mutability

  func setFlag(_ key: String, value: Bool) {
    boolFlags[key] = value
  }

  func setStringFlag(_ key: String, value: String) {
    stringFlags[key] = value
  }

  func setIntFlag(_ key: String, value: Int64) {
    intFlags[key] = value
  }

  func setDoubleFlag(_ key: String, value: Double) {
    doubleFlags[key] = value
  }

  func setObjectFlag(_ key: String, value: Value) {
    objectFlags[key] = value
  }
}
