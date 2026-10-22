import FeatherApplication
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.Folder.Table.Row {
    var asListItem: Asset.Folder.List.Output.Item {
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

extension Asset.Folder.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list(parentId: String?) async throws
            -> Asset.Folder.List.Output
        {
            let rows = try await Asset.Folder
                .Table(
                    connection: context.connection
                )
                .list(parentId: parentId)
            return .init(items: rows.map(\.asListItem))
        }
    }
}
