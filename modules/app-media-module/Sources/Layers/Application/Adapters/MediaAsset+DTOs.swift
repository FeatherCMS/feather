public import MediaDomain

extension MediaAssetNodeFile {
    public func asDetail(
        objectKeyGenerator: any ObjectKeyGenerator =
            HierarchicalObjectKeyGenerator()
    )
        throws -> MediaAssetDetail
    {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            url: try mediaAssetPublicURL(
                id: id,
                slugPath: slugPath,
                filename: name,
                extension: `extension`,
                objectKeyGenerator: objectKeyGenerator
            ),
            extension: `extension`,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: status.rawValue,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public func asListItem(
        objectKeyGenerator: any ObjectKeyGenerator =
            HierarchicalObjectKeyGenerator()
    )
        throws -> MediaAssetList.Item
    {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            url: try mediaAssetPublicURL(
                id: id,
                slugPath: slugPath,
                filename: name,
                extension: `extension`,
                objectKeyGenerator: objectKeyGenerator
            ),
            extension: `extension`,
            contentType: contentType,
            sizeBytes: sizeBytes,
            status: status.rawValue,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
