//
//  MediaProcessorAssetDatabaseRepository.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

extension MediaProcessorAssetTable.Row {
    var asDomain: MediaProcessorAsset {
        .init(
            id: id,
            assetId: assetId,
            processorId: processorId,
            storageKey: storageKey,
            createdAt: createdAt
        )
    }
}

public struct MediaProcessorAssetDatabaseRepository:
    MediaProcessorAssetRepository
{
    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func insert(
        _ model: MediaProcessorAsset.New
    ) async throws -> MediaProcessorAsset {
        let row = try await MediaProcessorAssetTable(
            connection: context.connection
        )
        .create(
            row: .init(
                id: context.idGenerator.generate(),
                assetId: model.assetId,
                processorId: model.processorId,
                storageKey: model.storageKey
            )
        )
        return row.asDomain
    }

    public func find(
        assetId: String,
        processorId: String
    ) async throws -> MediaProcessorAsset? {
        try await MediaProcessorAssetTable(connection: context.connection)
            .find(assetId: assetId, processorId: processorId)?
            .asDomain
    }

    public func list(
        assetId: String
    ) async throws -> [MediaProcessorAsset] {
        try await MediaProcessorAssetTable(connection: context.connection)
            .list(assetId: assetId).map(\.asDomain)
    }

    public func deleteAll(
        assetId: String
    ) async throws {
        try await MediaProcessorAssetTable(connection: context.connection)
            .deleteAll(assetId: assetId)
    }
}
