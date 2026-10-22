//
//  Metadata.Repository.Interface.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherDomain

extension Metadata {
    public enum Repository {}
}

extension Metadata.Repository {
    public protocol Interface: FeatherDomain.Repository {

        func find(
            id: String
        ) async throws -> Metadata.Model?

        func find(
            slug: String
        ) async throws -> Metadata.Model?

        func find(
            referenceType: String,
            referenceId: String
        ) async throws -> Metadata.Model?

        func insert(
            _ model: Metadata.Model.New
        ) async throws -> Metadata.Model

        func update(
            _ model: Metadata.Model
        ) async throws -> Metadata.Model

        func delete(
            ids: [String]
        ) async throws -> [String]

        func delete(
            referenceType: String,
            referenceIds: [String]
        ) async throws -> [String]
    }
}
