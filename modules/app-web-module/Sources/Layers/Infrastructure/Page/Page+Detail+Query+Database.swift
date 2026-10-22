import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Page.Table.Detail {
    func asDetail(metadata: Metadata.Detail.Output) -> Page.Detail.Output {
        .init(
            id: id,
            title: title,
            excerpt: excerpt,
            content: content,
            imageAssetId: imageAssetId,
            metadata: metadata,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Page.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public let metadata: any Metadata.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any Metadata.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Page.Detail.Output {
            guard
                let page = try await DatabaseAccessLayer<Page.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            guard
                let metadata = try await metadata.find(
                    referenceType: "web.page",
                    referenceID: id
                )
            else {
                throw RepositoryError.notFound
            }
            return page.asDetail(metadata: metadata)
        }
    }
}
