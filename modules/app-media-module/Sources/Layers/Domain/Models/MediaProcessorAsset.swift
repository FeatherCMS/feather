//
//  MediaProcessorAsset.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain

import struct Foundation.Date

public struct MediaProcessorAsset: Model {
    public struct New: Sendable {
        public let assetId: String
        public let processorId: String
        public let storageKey: String
    }

    public let id: String
    public let assetId: String
    public let processorId: String
    public let storageKey: String
    public let createdAt: Date

    package init(
        id: String,
        assetId: String,
        processorId: String,
        storageKey: String,
        createdAt: Date
    ) {
        self.id = id
        self.assetId = assetId
        self.processorId = processorId
        self.storageKey = storageKey
        self.createdAt = createdAt
    }
}

extension MediaProcessorAsset {
    public static func create(
        assetId: String,
        processorId: String,
        storageKey: String
    ) -> Self.New {
        .init(
            assetId: assetId,
            processorId: processorId,
            storageKey: storageKey
        )
    }
}
