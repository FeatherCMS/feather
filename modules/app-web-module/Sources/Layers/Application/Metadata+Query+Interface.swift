//
//  Metadata.Query.Interface.swift
//  app-web-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import WebModule

extension Metadata {
    public enum Query {}
}

extension Metadata.Query {
    public protocol Interface: Sendable {

        func find(
            id: String
        ) async throws -> Metadata.Detail.Output

        func find(
            referenceType: String,
            referenceID: String
        ) async throws -> Metadata.Detail.Output?

        func find(
            referenceType: String,
            slug: String
        ) async throws -> Metadata.Detail.Output?

        func resolve(
            slug: String
        ) async throws -> Metadata.Detail.Output?

        func resolve(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [Metadata.List.Output.Item]

        func resolveDetails(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [Metadata.Detail.Output]

    }
}
