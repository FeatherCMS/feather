//
//  MediaAssetDatabaseQueries.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import MediaApplication

extension MediaAssetTable.Row {
    var asDetail: MediaAssetDetail {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }

    var asListItem: MediaAssetList.Item {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asResolveItem: MediaAssetResolve.Item {
        .init(
            id: id,
            storageKey: storageKey,
            type: type,
            title: title,
            altText: altText,
            variants: []
        )
    }
}

public struct MediaAssetDatabaseQueries: MediaAssetQueries {
    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    private func pageSizeOffset(
        _ page: Search.Page
    ) -> (size: Int, offset: Int) {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func sortDirectionSQL(
        _ direction: Search.SortDirection
    ) -> String {
        switch direction {
        case .asc: "ASC"
        case .desc: "DESC"
        }
    }

    private func orderBy(
        _ query: MediaAssetList.Query
    ) -> String {
        let sortParts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id: column = "id"
            case .storageKey: column = "storage_key"
            case .type: column = "type"
            case .sizeBytes: column = "size_bytes"
            case .status: column = "status"
            case .title: column = "title"
            case .createdAt: column = "created_at"
            case .updatedAt: column = "updated_at"
            }
            return "\(column) \(sortDirectionSQL(rule.direction))"
        }
        return (sortParts + ["id ASC"]).joined(separator: ", ")
    }

    public func find(
        id: String
    ) async throws -> MediaAssetDetail {
        let table = MediaAssetTable(connection: context.connection)
        guard let row = try await table.find(id: id) else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func resolve(
        ids: [String],
        variants: [String]?
    ) async throws -> MediaAssetResolve {
        let assetRows = try await MediaAssetTable(
            connection: context.connection
        )
        .resolve(ids: ids)
        let variantRows = try await MediaProcessorAssetTable(
            connection: context.connection
        )
        .resolve(
            assetIDs: ids,
            variantNames: variants
        )
        var variantsByAssetID: [String: [MediaAssetResolve.Variant]] = [:]
        for variant in variantRows {
            variantsByAssetID[variant.assetId, default: []]
                .append(
                    .init(
                        name: variant.name,
                        storageKey: variant.storageKey
                    )
                )
        }
        return .init(
            items: assetRows.map { row in
                .init(
                    id: row.id,
                    storageKey: row.storageKey,
                    type: row.type,
                    title: row.title,
                    altText: row.altText,
                    variants: variantsByAssetID[row.id] ?? []
                )
            }
        )
    }

    public func findByStorageKey(
        _ storageKey: String
    ) async throws -> MediaAssetDetail? {
        try await MediaAssetTable(connection: context.connection)
            .find(storageKey: storageKey)?
            .asDetail
    }

    public func list(
        query: MediaAssetList.Query
    ) async throws -> MediaAssetList {
        let page = pageSizeOffset(query.page)
        let rows = try await MediaAssetTable(connection: context.connection)
            .list(
                parentId: query.parentId,
                search: query.search,
                orderBy: orderBy(query),
                limit: page.size,
                offset: page.offset
            )
        return .init(items: rows.map { $0.asListItem })
    }

    public func count(
        query: MediaAssetList.Query
    ) async throws -> Int {
        try await MediaAssetTable(connection: context.connection)
            .count(parentId: query.parentId, search: query.search)
    }
}
