public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension BlogApplication.Public.Author.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Output {
            guard
                let result = try await DatabaseAccessLayer<BlogModule.Author.Table>(
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
                id: result.id,
                name: result.name,
                excerpt: result.excerpt,
                content: result.content,
                profileImageAssetId: result.profileImageAssetId
            )
        }

        public func links(authorID: String) async throws -> [Link] {
            let result = try await DatabaseAccessLayer<BlogModule.AuthorLink.Table>(
                context: context
            )
            .select(as: BlogModule.AuthorLink.Table.List.self) {
                $0.where(\.authorId, equals: authorID).order(by: \.priority)
            }
            return result.map {
                .init(label: $0.label, url: $0.url, isBlank: $0.isBlank)
            }
        }

        public func posts(authorID: String) async throws -> [Post] {
            let result = try await DatabaseAccessLayer<BlogModule.Post.Table>(
                context: context
            )
            .select(as: BlogModule.Post.Table.Detail.self) {
                $0.order(by: [
                    .init(by: \.createdAt, .descending),
                    .init(by: \.id, .ascending),
                ])
                .limit(10_000)
            }
            return try result.compactMap { row in
                let authorIDs = try JSONDecoder().decode(
                    [String].self,
                    from: Data(row.authorIds.utf8)
                )
                guard authorIDs.contains(authorID) else { return nil }
                return .init(
                    id: row.id,
                    title: row.title,
                    excerpt: row.excerpt,
                    imageAssetId: row.imageAssetId
                )
            }
        }
    }
}
