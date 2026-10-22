public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Tag.Detail.Query {
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

        public func find(id: String) async throws -> Tag.Detail.Output {
            try await BlogApplication.Public.Query.TagContent
                .Database(
                    context: context,
                    metadata: metadata
                )
                .find(id: id)
        }
    }
}
