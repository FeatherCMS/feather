import FeatherApplication
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.Folder.Table.Row {
    var asDetail: Asset.Folder.Detail.Output {
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

extension Asset.Folder.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Asset.Folder.Detail.Output
        {
            guard
                let row = try await Asset.Folder
                    .Table(
                        connection: context.connection
                    )
                    .find(id: id)
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail
        }
    }
}
