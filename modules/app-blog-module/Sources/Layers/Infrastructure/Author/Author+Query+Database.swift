public import BlogApplication
public import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension Author.Query {
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

        public func find(id: String) async throws -> Author.Detail.Output {
            try await Author.Detail.Query
                .Database(
                    context: context,
                    metadata: metadata
                )
                .find(id: id)
        }

        public func list() async throws -> Author.List.Output {
            try await Author.List.Query.Database(context: context).list()
        }

        public func list(query: Author.Search.Input.Query) async throws
            -> Author.Search.Output
        {
            try await Author.Search.Query.Database(context: context)
                .search(query: query)
        }
    }
}
