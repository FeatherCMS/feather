import MediaDomain

public extension MediaAsset {
    var asDetail: MediaAssetDetail {
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

    var asListItem: MediaAssetList.Item {
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
