public import BlogApplication
public import BlogModule
public import FeatherInfrastructure
public import WebApplication
public import WebModule

extension Tag.List.Query {
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

        public func list() async throws -> Tag.List.Output {
            try await BlogApplication.Public.Tag.Database(
                    context: context,
                    metadata: metadata
                )
                .list(query: .init())
        }
    }
}
