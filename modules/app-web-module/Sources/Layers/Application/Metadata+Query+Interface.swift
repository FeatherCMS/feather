//
//  Metadata.Query.Interface.swift
//  app-web-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import WebDomain

extension Metadata {
    public enum Query {}
    }

    extension Metadata.Query {
    public protocol Interface: Sendable {

        func find(
            id: String
        ) async throws -> MetadataDetail

        func find(
            referenceType: String,
            referenceID: String
        ) async throws -> MetadataDetail?

        func find(
            referenceType: String,
            slug: String
        ) async throws -> MetadataDetail?

        func resolve(
            slug: String
        ) async throws -> MetadataDetail?

        func resolve(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [Metadata.List.Output.Item]

        func resolveDetails(
            referenceType: String,
            referenceIDs: [String]
        ) async throws -> [MetadataDetail]

    }
}
