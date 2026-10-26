public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure

extension AuthorLink.Table.Detail {
    var asPublicDetailQueryOutput: Public.AuthorLink.Detail.Query.Output {
        .init(
            id: id,
            authorId: authorId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Public.AuthorLink.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Output {
            guard
                let row = try await DatabaseAccessLayer<AuthorLink.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.id,
                    equals: id,
                    as: AuthorLink.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return row.asPublicDetailQueryOutput
        }
    }
}
