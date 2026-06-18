import Domain
import FeatherDatabase
import Infrastructure
import WebDomain

extension WebMetadataTable.Row {
    var asDomain: Metadata {
        let reference: Metadata.Reference? =
            if let referenceType, let referenceID {
                .init(type: referenceType, id: referenceID)
            }
            else {
                nil
            }
        return .init(
            id: id,
            reference: reference,
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

public struct DatabaseMetadataRepository: MetadataRepository {

    public var connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func insert(
        _ model: Metadata.New
    ) async throws -> Metadata {
        let table = WebMetadataTable(connection: connection)
        let saved = try await table.create(
            row: .init(
                id: model.id,
                referenceType: model.reference?.type,
                referenceID: model.reference?.id,
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
        let table = WebMetadataTable(connection: connection)
        return try await table.find(id: id)?.asDomain
    }

    public func find(
        slug: String
    ) async throws -> Metadata? {
        let table = WebMetadataTable(connection: connection)
        return try await table.find(slug: slug)?.asDomain
    }

    public func find(
        reference: Metadata.Reference
    ) async throws -> Metadata? {
        let table = WebMetadataTable(connection: connection)
        return try await table.find(
            referenceType: reference.type,
            referenceID: reference.id
        )?
        .asDomain
    }

    public func update(
        _ model: Metadata
    ) async throws -> Metadata {
        let table = WebMetadataTable(connection: connection)
        let updated = try await table.update(
            id: model.id,
            row: .init(
                id: model.id,
                referenceType: model.reference?.type,
                referenceID: model.reference?.id,
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
        id: String
    ) async throws -> Bool {
        let table = WebMetadataTable(connection: connection)
        return try await table.delete(id: id)
    }

    public func delete(
        reference: Metadata.Reference
    ) async throws -> Bool {
        let table = WebMetadataTable(connection: connection)
        return try await table.delete(
            referenceType: reference.type,
            referenceID: reference.id
        )
    }
}
