public import BlogApplication
import BlogModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension BlogApplication.Public.Tag.Detail.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext
        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> Output {
            guard
                let result = try await DatabaseAccessLayer<
                    BlogModule.Tag.Table
                >(
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
                id: result.id,
                title: result.title,
                excerpt: result.excerpt,
                content: result.content,
                imageAssetId: result.imageAssetId
            )
        }

        public func posts(tagID: String) async throws -> [Post] {
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
                let tagIDs = try JSONDecoder()
                    .decode(
                        [String].self,
                        from: Data(row.tagIds.utf8)
                    )
                guard tagIDs.contains(tagID) else { return nil }
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
