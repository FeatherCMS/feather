public import BlogApplication
public import BlogModule
public import FeatherInfrastructure

extension AuthorLink.Detail.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> AuthorLink.Detail.Output {
            try await Public.Query.AuthorLinkContent.Database(context: context)
                .find(id: id)
        }
    }
}
