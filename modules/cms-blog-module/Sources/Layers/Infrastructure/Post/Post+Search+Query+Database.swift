public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
import WebApplication
import WebInfrastructure
import WebModule

extension Post.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext
        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            query: Post.Search.Input.Query
        ) async throws -> Post.Search.Output {
            let matchingMetadataIDs = try await metadataIDs(
                referenceType: "blog.post",
                status: query.status
            )
            if matchingMetadataIDs?.isEmpty == true {
                return .init(items: [], total: 0)
            }
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let rows = try await DatabaseAccessLayer<Post.Table>(
                context: context
            )
            .select(as: Post.Table.List.self) { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Post.Table>(\.id),
                            DatabaseQueryTextColumn<Post.Table>(\.title),
                            DatabaseQueryTextColumn<Post.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Post.Table>(\.content),
                        ]
                    )
                }
                if let matchingMetadataIDs {
                    result = result.where(\.id, in: matchingMetadataIDs)
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<Post.Table>(by: \.id, direction)
                    case .title:
                        DatabaseQueryOrder<Post.Table>(by: \.title, direction)
                    case .createdAt:
                        DatabaseQueryOrder<Post.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<Post.Table>(
                            by: \.updatedAt,
                            direction
                        )
                    }
                }
                return
                    result
                    .order(by: orders + [.init(by: \.id, .ascending)])
                    .limit(page.size)
                    .offset(offset)
            }
            let total = try await DatabaseAccessLayer<Post.Table>(
                context: context
            )
            .selectCount { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<Post.Table>(\.id),
                            DatabaseQueryTextColumn<Post.Table>(\.title),
                            DatabaseQueryTextColumn<Post.Table>(\.excerpt),
                            DatabaseQueryTextColumn<Post.Table>(\.content),
                        ]
                    )
                }
                if let matchingMetadataIDs {
                    result = result.where(\.id, in: matchingMetadataIDs)
                }
                return result
            }
            let items = rows.map { item in
                Post.Search.Output.Item(
                    id: item.id,
                    title: item.title,
                    excerpt: item.excerpt,
                    imageAssetId: item.imageAssetId,
                    createdAt: item.createdAt,
                    updatedAt: item.updatedAt
                )
            }
            return .init(items: items, total: total)
        }

        private func metadataIDs(
            referenceType: String,
            status: String?
        ) async throws -> [String]? {
            guard let status else { return nil }
            return try await WebModule.Metadata.Search.Query.Database(
                context: context
            )
            .matchingReferenceIDs(
                referenceType: referenceType,
                status: status
            )
        }
    }
}
