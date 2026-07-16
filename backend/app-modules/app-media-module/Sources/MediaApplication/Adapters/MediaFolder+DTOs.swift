//
//  MediaFolder+DTOs.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

import MediaDomain

extension MediaFolder {
    public var asDetail: MediaFolderDetail {
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

    public var asListItem: MediaFolderList.Item {
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
