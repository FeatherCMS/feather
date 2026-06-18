import MediaDomain

public extension MediaFolder {
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
