//
//  MetadataRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

public protocol MetadataRepository: Repository {

    func find(
        id: String
    ) async throws -> Metadata?

    func find(
        slug: String
    ) async throws -> Metadata?

    func find(
        referenceType: String,
        referenceId: String
    ) async throws -> Metadata?

    func insert(
        _ model: Metadata.New
    ) async throws -> Metadata

    func update(
        _ model: Metadata
    ) async throws -> Metadata

    func delete(
        ids: [String]
    ) async throws -> [String]

    func delete(
        referenceType: String,
        referenceIds: [String]
    ) async throws -> [String]
}
