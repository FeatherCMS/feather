public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Post.List.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        let metadata: any Metadata.Query.Interface

        public init(
            context: DatabaseQueryContext,
            metadata: any Metadata.Query.Interface
        ) {
            self.context = context
            self.metadata = metadata
        }

        public func list() async throws -> Post.List.Output {
            try await Public.Query.PostContent
                .Database(
                    context: context,
                    metadata: metadata
                )
                .list(query: .init())
        }
    }
}
