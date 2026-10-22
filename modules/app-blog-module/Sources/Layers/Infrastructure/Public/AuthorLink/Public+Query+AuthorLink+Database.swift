public import BlogApplication
public import BlogModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure

extension AuthorLink.Table.List {
    var asQueryItem: AuthorLink.List.Output.Item {
        .init(
            id: id,
            authorId: authorId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension AuthorLink.Table.Detail {
    var asDetail: AuthorLink.Detail.Output {
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

extension BlogApplication.Public.AuthorLink {
    public struct Database: List.Query.Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func find(id: String) async throws -> AuthorLink.Detail.Output {
            guard
                let detail = try await DatabaseAccessLayer<AuthorLink.Table>(
                    context: context
                )
                .selectFirst(by: \.id, equals: id)
            else {
                throw RepositoryError.notFound
            }
            return detail.asDetail
        }

        public func list(
            authorId: String,
            query: AuthorLink.Search.Input.Query
        ) async throws -> AuthorLink.List.Output {
            let accessLayer = DatabaseAccessLayer<AuthorLink.Table>(
                context: context
            )
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
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
                let orders = query.sort.map { sort in
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
                return
                    result
                    .order(by: orders + [.init(by: \.id, .ascending)])
                    .limit(page.size)
                    .offset(offset)
            }
            return .init(items: items.map(\.asQueryItem))
        }

        public func count(
            authorId: String,
            query: AuthorLink.Search.Input.Query
        ) async throws -> Int {
            try await DatabaseAccessLayer<AuthorLink.Table>(context: context)
                .selectCount { initial in
                    var result = initial.where(\.authorId, equals: authorId)
                    if let search = query.search {
                        result = result.where(
                            searchText: search,
                            columns: [
                                DatabaseQueryTextColumn<AuthorLink.Table>(\.id),
                                DatabaseQueryTextColumn<AuthorLink.Table>(
                                    \.label
                                ),
                                DatabaseQueryTextColumn<AuthorLink.Table>(
                                    \.url
                                ),
                                DatabaseQueryTextColumn<AuthorLink.Table>(
                                    \.permission
                                ),
                                DatabaseQueryTextColumn<AuthorLink.Table>(
                                    \.notes
                                ),
                            ]
                        )
                    }
                    return result
                }
        }
    }
}
