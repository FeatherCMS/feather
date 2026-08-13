//
//  MediaFolderDatabaseQueries.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure
import MediaApplication

extension MediaFolderTable.Row {
    var asDetail: MediaFolderDetail {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            path: path,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asListItem: MediaFolderList.Item {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            path: path,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MediaFolderDatabaseQueries: MediaFolderQueries {
    public let context: DatabaseQueryContext

    public init(context: DatabaseQueryContext) {
        self.context = context
    }

    public func find(
        id: String
    ) async throws -> MediaFolderDetail {
        guard
            let row = try await MediaFolderTable(connection: context.connection)
                .find(
                    id: id
                )
        else {
            throw RepositoryError.notFound
        }
        return row.asDetail
    }

    public func list(
        query: MediaFolderList.Query
    ) async throws -> MediaFolderList {
        let rows = try await MediaFolderTable(connection: context.connection)
            .list(
                parentId: query.parentId
            )
        return .init(items: rows.map(\.asListItem))
    }
}
