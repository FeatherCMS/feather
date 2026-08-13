//
//  MediaAssetDatabaseRepository.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

extension MediaAssetTable.Row {
    var asDomain: MediaAsset {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: .init(rawValue: status) ?? .uploaded,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }
}

public struct MediaAssetDatabaseRepository: MediaAssetRepository {
    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: MediaAsset.New
    ) async throws -> MediaAsset {
        let table = MediaAssetTable(connection: context.connection)
        let row = try await table.create(
            row: .init(
                id: context.idGenerator.generate(),
                folderId: model.folderId,
                storageKey: model.storageKey,
                baseName: model.baseName,
                type: model.type,
                sizeBytes: model.sizeBytes,
                status: model.status.rawValue,
                title: model.title,
                altText: model.altText
            )
        )
        return row.asDomain
    }

    public func update(
        _ model: MediaAsset
    ) async throws -> MediaAsset {
        let table = MediaAssetTable(connection: context.connection)
        let row = try await table.update(
            row: .init(
                id: model.id,
                folderId: model.folderId,
                storageKey: model.storageKey,
                baseName: model.baseName,
                type: model.type,
                sizeBytes: model.sizeBytes,
                status: model.status.rawValue,
                title: model.title,
                altText: model.altText,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt,
                deletedAt: model.deletedAt
            )
        )
        return row.asDomain
    }

    public func find(
        id: String
    ) async throws -> MediaAsset? {
        let table = MediaAssetTable(connection: context.connection)
        return try await table.find(id: id)?.asDomain
    }

    public func find(
        storageKey: String
    ) async throws -> MediaAsset? {
        let table = MediaAssetTable(connection: context.connection)
        return try await table.find(storageKey: storageKey)?.asDomain
    }

    public func list(
        folderIds: [String]
    ) async throws -> [MediaAsset] {
        try await MediaAssetTable(connection: context.connection)
            .list(folderIds: folderIds)
            .map(\.asDomain)
    }

    public func delete(
        id: String
    ) async throws -> Bool {
        let table = MediaAssetTable(connection: context.connection)
        return try await table.hardDelete(id: id)
    }
}
