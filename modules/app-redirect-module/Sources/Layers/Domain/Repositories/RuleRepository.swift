//
//  RuleRepository.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol RuleRepository: Repository {

    func find(
        id: String
    ) async throws -> Rule?

    func find(
        source: String
    ) async throws -> Rule?

    func insert(
        _ model: Rule.New
    ) async throws -> Rule

    func update(
        _ model: Rule
    ) async throws -> Rule

    func delete(
        ids: [String]
    ) async throws -> Bool
}
