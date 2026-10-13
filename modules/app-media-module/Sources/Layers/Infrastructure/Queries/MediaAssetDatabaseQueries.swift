import FeatherApplication
public import FeatherDomain
public import FeatherInfrastructure
public import MediaApplication

extension MediaAssetNodeFileTable.Row {
    func asDetail(
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
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    func asListItem(
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
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct MediaAssetDatabaseQueries: MediaAssetQueries {
    public let context: DatabaseQueryContext
    public let objectKeyGenerator: any ObjectKeyGenerator
    public init(
        context: DatabaseQueryContext,
        objectKeyGenerator: any ObjectKeyGenerator =
            HierarchicalObjectKeyGenerator()
    ) {
        self.context = context
        self.objectKeyGenerator = objectKeyGenerator
    }

    private func pageSizeOffset(_ page: Search.Page) -> (size: Int, offset: Int)
    {
        let size = max(1, page.size)
        let number = max(1, page.number)
        return (size, (number - 1) * size)
    }

    private func orderBy(_ query: MediaAssetList.Query) -> String {
        let parts = query.sort.map { rule -> String in
            let column: String
            switch rule.field {
            case .id: column = "n.id"
            case .name: column = "n.name"
            case .slugPath: column = MediaAssetNodeSlugPath.sql
            case .extension: column = "o.extension"
            case .sizeBytes: column = "o.size_in_bytes"
            case .status: column = "f.status"
            case .title: column = "f.title"
            case .createdAt: column = "n.created_at"
            case .updatedAt: column = "n.updated_at"
            }
            let direction = rule.direction == .asc ? "ASC" : "DESC"
            return "\(column) \(direction)"
        }
        return (parts + ["n.id ASC"]).joined(separator: ", ")
    }

    public func find(id: String) async throws -> MediaAssetDetail {
        guard
            let row = try await MediaAssetNodeFileTable(
                connection: context.connection
            )
            .find(id: id)
        else { throw RepositoryError.notFound }
        return try row.asDetail(objectKeyGenerator: objectKeyGenerator)
    }

    public func resolve(ids: [String], variants: [String]?) async throws
        -> MediaAssetResolve
    {
        let assets = try await MediaAssetNodeFileTable(
            connection: context.connection
        )
        .resolve(ids: ids)
        let variantRows = try await MediaAssetVariantTable(
            connection: context.connection
        )
        .resolve(nodeIds: ids, variantKeys: variants)
        var variantsByAsset: [String: [MediaAssetResolve.Variant]] = [:]
        let assetsByID = Dictionary(
            uniqueKeysWithValues: assets.map { ($0.id, $0) }
        )
        for variant in variantRows {
            guard let asset = assetsByID[variant.assetNodeFileId] else {
                continue
            }
            variantsByAsset[variant.assetNodeFileId, default: []]
                .append(
                    .init(
                        id: variant.id,
                        key: variant.key,
                        name: variant.name,
                        url: try mediaVariantPublicURL(
                            assetId: variant.assetNodeFileId,
                            slugPath: asset.slugPath,
                            filename: asset.name,
                            variantKey: variant.key,
                            extension: variant.extension,
                            objectKeyGenerator: objectKeyGenerator
                        ),
                        extension: variant.extension
                    )
                )
        }
        return .init(
            items: try assets.map {
                .init(
                    id: $0.id,
                    url: try mediaAssetPublicURL(
                        id: $0.id,
                        slugPath: $0.slugPath,
                        filename: $0.name,
                        extension: $0.extension,
                        objectKeyGenerator: objectKeyGenerator
                    ),
                    extension: $0.extension,
                    title: $0.title,
                    altText: $0.altText,
                    variants: variantsByAsset[$0.id] ?? []
                )
            }
        )
    }

    public func list(query: MediaAssetList.Query) async throws -> MediaAssetList
    {
        let page = pageSizeOffset(query.page)
        let rows = try await MediaAssetNodeFileTable(
            connection: context.connection
        )
        .list(
            parentId: query.parentId,
            search: query.search,
            orderBy: orderBy(query),
            limit: page.size,
            offset: page.offset
        )
        return .init(
            items: try rows.map {
                try $0.asListItem(objectKeyGenerator: objectKeyGenerator)
            }
        )
    }

    public func count(query: MediaAssetList.Query) async throws -> Int {
        try await MediaAssetNodeFileTable(connection: context.connection)
            .count(parentId: query.parentId, search: query.search)
    }
}
