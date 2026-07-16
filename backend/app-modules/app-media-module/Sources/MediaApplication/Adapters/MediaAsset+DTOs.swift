//
//  MediaAsset+DTOs.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import MediaDomain

extension MediaAsset {
    public var asDetail: MediaAssetDetail {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: status.rawValue,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt
        )
    }

    public var asListItem: MediaAssetList.Item {
        .init(
            id: id,
            folderId: folderId,
            storageKey: storageKey,
            baseName: baseName,
            type: type,
            sizeBytes: sizeBytes,
            status: status.rawValue,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
