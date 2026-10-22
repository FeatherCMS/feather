public import FeatherDomain
public import MediaDomain
public import MediaModule

extension Asset.File.Model {
    public func asDetail(
        objectKeyGenerator: any ObjectKeyGenerator
    )
        throws -> Asset.File.Detail.Output
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

    public func asSearchItem(
        objectKeyGenerator: any ObjectKeyGenerator
    )
        throws -> Asset.File.Search.Output.AssetItem
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
