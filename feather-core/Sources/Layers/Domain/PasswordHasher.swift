//
//  PasswordHasher.swift
//  feather-core
//
//  Created by Binary Birds on 2026. 06. 18.

public protocol PasswordHasher: Sendable {
    func hash(
        _ original: String
    ) async throws -> String
    func verify(
        _ original: String,
        hash: String
    ) async throws -> Bool
}
