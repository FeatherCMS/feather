public import MediaDomain
public import MediaModule

extension Asset.Folder.Model {
    public var asDetail: Asset.Folder.Detail.Output {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public var asListItem: Asset.Folder.List.Output.Item {
        .init(
            id: id,
            parentId: parentId,
            name: name,
            slug: slug,
            slugPath: slugPath,
            assetCount: assetCount,
            totalSizeBytes: totalSizeBytes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
