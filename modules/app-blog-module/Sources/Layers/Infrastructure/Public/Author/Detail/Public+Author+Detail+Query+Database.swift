public import BlogApplication
import BlogModule
public import FeatherInfrastructure
import WebDomain
public import WebApplication
public import WebModule

extension BlogApplication.Public.Author.Detail.Query {
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

        public func find(id: String) async throws -> Output {
            let result = try await Author.Detail.Query
                .Database(
                    context: context,
                    metadata: metadata
                )
                .find(id: id)
            return .init(
                id: result.id,
                name: result.name,
                excerpt: result.excerpt,
                content: result.content,
                profileImageAssetId: result.profileImageAssetId
            )
        }
    }
}
