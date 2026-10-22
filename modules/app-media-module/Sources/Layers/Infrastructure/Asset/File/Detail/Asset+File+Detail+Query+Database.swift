import FeatherApplication
public import FeatherDomain
public import FeatherInfrastructure
public import MediaApplication
public import MediaModule

extension Asset.File.Table.Row {
    func asDetail(
        objectKeyGenerator: any ObjectKeyGenerator =
            HierarchicalObjectKeyGenerator()
    ) throws -> Asset.File.Detail.Output {
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

extension Asset.File.Detail.Query {
    public struct Database: Interface {
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

        public func find(id: String) async throws -> Asset.File.Detail.Output {
            guard
                let row = try await Asset.File
                    .Table(
                        connection: context.connection
                    )
                    .find(id: id)
            else {
                throw RepositoryError.notFound
            }
            return try row.asDetail(objectKeyGenerator: objectKeyGenerator)
        }
    }
}
