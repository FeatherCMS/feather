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
            let value = try await BlogApplication.Public.AuthorLink.Detail.Query
                .Database(
                    context: context
                )
                .find(id: id)
            return .init(
                id: value.id,
                authorId: value.authorId,
                label: value.label,
                url: value.url,
                priority: value.priority,
                isBlank: value.isBlank,
                permission: value.permission,
                notes: value.notes,
                createdAt: value.createdAt,
                updatedAt: value.updatedAt
            )
        }
    }
}
