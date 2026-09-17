import MediaDomain

extension MediaAssetNodeFolder {
    public var asDetail: MediaFolderDetail {
        .init(id: id, parentId: parentId, name: name, slug: slug, slugPath: slugPath, assetCount: assetCount, totalSizeBytes: totalSizeBytes, createdAt: createdAt, updatedAt: updatedAt)
    }

    public var asListItem: MediaFolderList.Item {
        .init(id: id, parentId: parentId, name: name, slug: slug, slugPath: slugPath, assetCount: assetCount, totalSizeBytes: totalSizeBytes, createdAt: createdAt, updatedAt: updatedAt)
    }
}
