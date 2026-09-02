//
//  MetadataDatabaseRepository.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import WebDomain

extension WebMetadataTable.Row {

    var asDomain: Metadata {
        .init(
            id: id,
            reference: .existing(.init(type: referenceType, id: referenceID)),
            template: template,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: .init(rawValue: status) ?? .draft,
            title: titleOverride,
            excerpt: excerptOverride,
            imageURL: imageURLOverride,
            canonicalURL: canonicalURL,
            noIndex: noIndex,
            primaryKeyword: primaryKeyword,
            cssCodeInjection: cssCodeInjection,
            javascriptCodeInjection: javascriptCodeInjection,
            structuredDataCodeInjection: structuredDataCodeInjection,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MetadataDatabaseRepository: MetadataRepository {

    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: Metadata.New
    ) async throws -> Metadata {

        //TODO:

        guard let referenceID = model.reference.id else {
            throw RepositoryError(
                reason: .unknown,
                logMessage: "Metadata reference identifier is missing.",
                userFriendlyMessage: "Metadata reference identifier is missing."
            )
        }

        let table = WebMetadataTable(connection: context.connection)
        let saved = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                referenceType: model.reference.type,
                referenceID: referenceID,
                template: model.template,
                slug: model.slug,
                publicationDate: model.publicationDate,
                expirationDate: model.expirationDate,
                status: model.status.rawValue,
                titleOverride: model.title,
                excerptOverride: model.excerpt,
                imageURLOverride: model.imageURL,
                canonicalURL: model.canonicalURL,
                noIndex: model.noIndex,
                primaryKeyword: model.primaryKeyword,
                cssCodeInjection: model.cssCodeInjection,
                javascriptCodeInjection: model.javascriptCodeInjection,
                structuredDataCodeInjection: model.structuredDataCodeInjection
            )
        )
        return saved.asDomain
    }

    public func find(
        id: String
    ) async throws -> Metadata? {
        let table = WebMetadataTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func find(
        slug: String
    ) async throws -> Metadata? {
        let table = WebMetadataTable(connection: context.connection)
        return try await table.find(slug: slug)?.asDomain
    }

    public func find(
        reference: Metadata.Reference
    ) async throws -> Metadata? {
        let table = WebMetadataTable(connection: context.connection)
        guard let referenceID = reference.id else {
            return nil
        }
        return try await table.find(
            referenceType: reference.type,
            referenceID: referenceID
        )?
        .asDomain
    }

    public func update(
        _ model: Metadata
    ) async throws -> Metadata {
        guard let referenceID = model.reference.id else {
            throw RepositoryError(
                reason: .unknown,
                logMessage: "Metadata reference identifier is missing.",
                userFriendlyMessage: "Metadata reference identifier is missing."
            )
        }

        let table = WebMetadataTable(connection: context.connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                referenceType: model.reference.type,
                referenceID: referenceID,
                template: model.template,
                slug: model.slug,
                publicationDate: model.publicationDate,
                expirationDate: model.expirationDate,
                status: model.status.rawValue,
                titleOverride: model.title,
                excerptOverride: model.excerpt,
                imageURLOverride: model.imageURL,
                canonicalURL: model.canonicalURL,
                noIndex: model.noIndex,
                primaryKeyword: model.primaryKeyword,
                cssCodeInjection: model.cssCodeInjection,
                javascriptCodeInjection: model.javascriptCodeInjection,
                structuredDataCodeInjection: model.structuredDataCodeInjection,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        )
        return updated.asDomain
    }

    public func delete(
        ids: [String]
    ) async throws -> Bool {
        let table = WebMetadataTable(connection: context.connection)
        var removed = true
        for id in ids {
            removed = try await table.delete(id: id) && removed
        }
        return removed
    }

    public func delete(
        reference: Metadata.Reference
    ) async throws -> Bool {
        let table = WebMetadataTable(connection: context.connection)
        guard let referenceID = reference.id else {
            return false
        }
        return try await table.delete(
            referenceType: reference.type,
            referenceID: referenceID
        )
    }
}
