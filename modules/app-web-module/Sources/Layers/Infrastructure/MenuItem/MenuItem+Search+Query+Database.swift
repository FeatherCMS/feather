import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
public import WebApplication
public import WebDomain

extension MenuItem.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(
            menuId: String,
            query: MenuItem.Search.Input.Query
        ) async throws -> MenuItem.Search.Output {
            let accessLayer = DatabaseAccessLayer<MenuItem.Table>(
                context: context
            )
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max : pageIndex * page.size
            let items = try await accessLayer.select { initial in
                var result = initial.where(\.menuId, equals: menuId)
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<MenuItem.Table>(\.id),
                            DatabaseQueryTextColumn<MenuItem.Table>(\.label),
                            DatabaseQueryTextColumn<MenuItem.Table>(\.url),
                            DatabaseQueryTextColumn<MenuItem.Table>(
                                \.permission
                            ),
                        ]
                    )
                }
                let orders = query.sort.map { sort in
                    let direction: DatabaseQueryDirection =
                        sort.direction == .asc ? .ascending : .descending
                    return switch sort.field {
                    case .id:
                        DatabaseQueryOrder<MenuItem.Table>(by: \.id, direction)
                    case .label:
                        DatabaseQueryOrder<MenuItem.Table>(
                            by: \.label,
                            direction
                        )
                    case .url:
                        DatabaseQueryOrder<MenuItem.Table>(by: \.url, direction)
                    case .priority:
                        DatabaseQueryOrder<MenuItem.Table>(
                            by: \.priority,
                            direction
                        )
                    case .permission:
                        DatabaseQueryOrder<MenuItem.Table>(
                            by: \.permission,
                            direction
                        )
                    case .createdAt:
                        DatabaseQueryOrder<MenuItem.Table>(
                            by: \.createdAt,
                            direction
                        )
                    case .updatedAt:
                        DatabaseQueryOrder<MenuItem.Table>(
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
            let total = try await accessLayer.selectCount { initial in
                var result = initial.where(\.menuId, equals: menuId)
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [
                            DatabaseQueryTextColumn<MenuItem.Table>(\.id),
                            DatabaseQueryTextColumn<MenuItem.Table>(\.label),
                            DatabaseQueryTextColumn<MenuItem.Table>(\.url),
                            DatabaseQueryTextColumn<MenuItem.Table>(
                                \.permission
                            ),
                        ]
                    )
                }
                return result
            }
            return .init(
                items: items.map {
                    .init(
                        id: $0.id,
                        menuId: $0.menuId,
                        label: $0.label,
                        url: $0.url,
                        priority: $0.priority,
                        isBlank: $0.isBlank,
                        permission: $0.permission,
                        authentication: MenuItem.Authentication(
                            rawValue: $0.authentication
                        ) ?? .any,
                        createdAt: $0.createdAt,
                        updatedAt: $0.updatedAt
                    )
                },
                total: total
            )
        }
    }
}
