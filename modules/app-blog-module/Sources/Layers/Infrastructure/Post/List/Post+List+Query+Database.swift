public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
import WebDomain
public import WebModule

extension Post.List.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        let metadata: any WebModule.Metadata.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any WebModule.Metadata.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func list() async throws -> Post.List.Output {
            try await BlogApplication.Public.Query.PostContent
                .Database(
                    context: context,
                    metadata: metadata
                )
                .list(query: .init())
        }
    }
}
