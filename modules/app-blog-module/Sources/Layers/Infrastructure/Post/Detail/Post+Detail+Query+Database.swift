public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Post.Detail.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        let metadata: any WebModule.Metadata.Reference.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Reference.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func find(id: String) async throws -> Post.Detail.Output {
            try await BlogApplication.Public.Post.Database(
                    context: context,
                    metadata: metadata
                )
                .find(id: id)
        }
    }
}
