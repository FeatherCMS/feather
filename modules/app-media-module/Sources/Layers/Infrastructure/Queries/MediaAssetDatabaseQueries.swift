import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherInfrastructure
import MediaApplication

extension MediaAssetNodeFileTable.Row {
    var asDetail: MediaAssetDetail {
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
            status: status,
            title: title,
            altText: altText,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asListItem: MediaAssetList.Item {
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
    public init(context: DatabaseQueryContext) { self.context = context }

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
            case .slugPath: column = "n.slug_path"
            case .extension: column = "f.extension"
            case .sizeBytes: column = "f.size_bytes"
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
        return row.asDetail
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
        for variant in variantRows {
            variantsByAsset[variant.nodeId, default: []]
                .append(
                    .init(
                        id: variant.id,
                        key: variant.key,
                        name: variant.name,
                        url: mediaVariantPublicURL(
                            assetId: variant.nodeId,
                            name: variant.key,
                            extension: variant.extension
                        ),
                        extension: variant.extension
                    )
                )
        }
        return .init(
            items: assets.map {
                .init(
                    id: $0.id,
                    url: mediaAssetPublicURL(
                        id: $0.id,
                        slugPath: $0.slugPath,
                        extension: $0.extension
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
        return .init(items: rows.map(\.asListItem))
    }

    public func count(query: MediaAssetList.Query) async throws -> Int {
        try await MediaAssetNodeFileTable(connection: context.connection)
            .count(parentId: query.parentId, search: query.search)
    }
}
