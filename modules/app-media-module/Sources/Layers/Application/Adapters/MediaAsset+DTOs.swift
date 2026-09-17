import MediaDomain

extension MediaAssetNodeFile {
    public var asDetail: MediaAssetDetail {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            url: mediaAssetPublicURL(
                id: id,
                slugPath: slugPath,
                extension: `extension`
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

    public var asListItem: MediaAssetList.Item {
        .init(
            id: id,
            folderId: folderId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            url: mediaAssetPublicURL(
                id: id,
                slugPath: slugPath,
                extension: `extension`
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
