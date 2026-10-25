public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Public.Post.List.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func list() async throws -> Output {
            let result = try await DatabaseAccessLayer<Post.Table>(
                context: context
            )
            .select(as: Post.Table.Detail.self) {
                $0.order(by: [
                    .init(by: \.createdAt, .descending),
                    .init(by: \.id, .ascending),
                ])
                .limit(10_000)
            }
            return .init(
                items: result.map {
                    .init(
                        id: $0.id,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageAssetId: $0.imageAssetId,
                        authorIds: try JSONDecoder().decode(
                            [String].self,
                            from: Data($0.authorIds.utf8)
                        ),
                        tagIds: try JSONDecoder().decode(
                            [String].self,
                            from: Data($0.tagIds.utf8)
                        )
                    )
                }
            )
        }

        public func findAuthor(id: String) async throws -> Author {
            guard
                let row = try await DatabaseAccessLayer<BlogModule.Author.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.id,
                    equals: id,
                    as: BlogModule.Author.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return .init(
                id: row.id,
                name: row.name,
                excerpt: row.excerpt,
                content: row.content,
                imageAssetId: row.profileImageAssetId
            )
        }

        public func findTag(id: String) async throws -> Tag {
            guard
                let row = try await DatabaseAccessLayer<BlogModule.Tag.Table>(
                    context: context
                )
                .selectFirst(
                    by: \.id,
                    equals: id,
                    as: BlogModule.Tag.Table.Detail.self
                )
            else {
                throw RepositoryError.notFound
            }
            return .init(
                id: row.id,
                title: row.title,
                excerpt: row.excerpt,
                imageAssetId: row.imageAssetId
            )
        }
    }
}
