public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension AuthorLink.Search.Query {
    public struct Database: Interface {
        let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            authorId: String,
            query: AuthorLink.Search.Input.Query
        ) async throws -> AuthorLink.Search.Output {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let accessLayer = DatabaseAccessLayer<AuthorLink.Table>(
                context: context
            )
            let items = try await accessLayer.select(
                as: AuthorLink.Table.List.self
            ) { initial in
                var result = initial.where(\.authorId, equals: authorId)
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.id),
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.label),
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.url),
                            DatabaseQueryTextColumn<AuthorLink.Table>(
                                \.permission
                            ),
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.notes),
                        ]
                    )
                }
                var orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.id,
                            direction
                        )
                    case .label:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.label,
                            direction
                        )
                    case .url:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.url,
                            direction
                        )
                    case .priority:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.priority,
                            direction
                        )
                    case .permission:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.permission,
                            direction
                        )
                    case .createdAt:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<AuthorLink.Table>(
                            by: \.updatedAt,
                            direction
                        )
                    }
                }
                if !query.sort.contains(where: { $0.field == .id }) {
                    orders.append(.init(by: \.id, .ascending))
                }
                return result.order(by: orders).limit(page.size).offset(offset)
            }
            let total = try await accessLayer.selectCount { initial in
                var result = initial.where(\.authorId, equals: authorId)
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.id),
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.label),
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.url),
                            DatabaseQueryTextColumn<AuthorLink.Table>(
                                \.permission
                            ),
                            DatabaseQueryTextColumn<AuthorLink.Table>(\.notes),
                        ]
                    )
                }
                return result
            }
            return .init(
                items: items.map {
                    .init(
                        id: $0.id,
                        authorId: authorId,
                        label: $0.label,
                        url: $0.url,
                        priority: $0.priority,
                        isBlank: $0.isBlank,
                        permission: $0.permission,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                },
                total: total
            )
        }
    }
}
