//
//  MetadataDatabaseQueries.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import WebApplication
import WebDomain

extension WebMetadataTable.Row {

    var asQueryListItem: MetadataList.Item {
        .init(
            id: id,
            referenceType: referenceType,
            referenceID: referenceID,
            slug: slug,
            publicationDate: publicationDate,
            expirationDate: expirationDate,
            status: .init(rawValue: status) ?? .draft,
            title: titleOverride ?? "",
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asDetail: MetadataDetail {
        .init(
            id: id,
            referenceType: referenceType,
            referenceID: referenceID,
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

public struct MetadataDatabaseQueries: MetadataQueries {

    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc:
            "ASC"
        case .desc:
            "DESC"
        }
    }

    func orderByMetadata(
        _ query: MetadataList.Query
    ) -> String {
        let sortParts = query.sort.map { entry -> String in
            let column: String
            switch entry.field {
            case .id:
                column = "id"
            case .referenceType:
                column = "reference_type"
            case .referenceID:
                column = "reference_id"
            case .slug:
                column = "slug"
            case .publicationDate:
                column = "publication_date"
            case .expirationDate:
                column = "expiration_date"
            case .status:
                column = "status"
            case .title:
                column = "title"
            case .createdAt:
                column = "created_at"
            case .updatedAt:
                column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(entry.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> MetadataDetail {
        let table = WebMetadataTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func find(
        referenceType: String,
        referenceID: String
    ) async throws -> MetadataDetail? {
        let table = WebMetadataTable(connection: context.connection)
        return try await table.find(
            referenceType: referenceType,
            referenceID: referenceID
        )?
        .asDetail
    }

    public func find(
        referenceType: String,
        slug: String
    ) async throws -> MetadataDetail? {
        let table = WebMetadataTable(connection: context.connection)
        return try await table.find(
            referenceType: referenceType,
            slug: slug
        )?
        .asDetail
    }

    public func resolve(
        slug: String
    ) async throws -> MetadataDetail? {
        let table = WebMetadataTable(connection: context.connection)
        return try await table.find(slug: slug)?.asDetail
    }

    public func list(
        query: MetadataList.Query
    ) async throws -> MetadataList {
        let page = pageSizeOffset(query.page)
        let table = WebMetadataTable(connection: context.connection)
        let items =
            try await table.list(
                search: query.search,
                referenceType: query.referenceType,
                orderBy: orderByMetadata(query),
                limit: page.size,
                offset: page.offset
            )
            .map(\.asQueryListItem)

        return .init(items: items)
    }

    public func count(
        query: MetadataList.Query
    ) async throws -> Int {
        let table = WebMetadataTable(connection: context.connection)
        return try await table.count(
            search: query.search,
            referenceType: query.referenceType
        )
    }
}
