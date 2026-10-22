public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Author.Table.Detail {
    func asDetail(metadata: WebModule.Metadata.Detail.Output)
        -> Author.Detail.Output
    {
        .init(
            id: id,
            name: name,
            excerpt: excerpt,
            content: content,
            profileImageAssetId: profileImageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Author.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Author.Detail.Output {
            guard
                let row = try await DatabaseAccessLayer<Author.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "blog.author",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asDetail(metadata: metadata)
        }
    }
}
