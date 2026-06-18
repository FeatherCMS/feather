//
//  File.swift
//  app-metadata-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

public protocol MetadataQueries: Sendable {

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

    func list(
        query: MetadataList.Query
    ) async throws -> MetadataList

    func count(
        query: MetadataList.Query
    ) async throws -> Int
}
