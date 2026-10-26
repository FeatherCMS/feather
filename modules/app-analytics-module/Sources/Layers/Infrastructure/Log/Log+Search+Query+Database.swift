public import AnalyticsApplication
public import AnalyticsModule
import FeatherApplication
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Log.Search.Query {
    public struct Database: Interface {
        public let context: DatabaseQueryContext

        public init(context: DatabaseQueryContext) {
            self.context = context
        }

        public func search(query: Log.Search.Input.Query) async throws
            -> Log.Search.Output
        {
            let page = query.page.normalized()
            let pageIndex = page.number - 1
            let offset =
                pageIndex > Int.max / page.size
                ? Int.max
                : pageIndex * page.size
            let accessLayer = DatabaseAccessLayer<Log.Table>(context: context)
            let rows = try await accessLayer.select(as: Log.Table.List.self) {
                initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [DatabaseQueryTextColumn<Log.Table>(\.path)]
                    )
                }
                if let source = query.source {
                    result = result.where(\.source, equals: source)
                }
                if let method = query.method {
                    result = result.where(\.method, equals: method)
                }
                if let responseCode = query.responseCode {
                    result = result.where(\.responseCode, equals: responseCode)
                }
                if let from = query.from {
                    result = result.where(
                        \.createdAt,
                        greaterThanOrEqualTo: Date(timeIntervalSince1970: from)
                    )
                }
                if let to = query.to {
                    result = result.where(
                        \.createdAt,
                        lessThan: Date(timeIntervalSince1970: to)
                    )
                }
                var orders = query.sort.map { rule in
                    let direction: DatabaseQueryDirection =
                        rule.direction == .asc ? .ascending : .descending
                    return switch rule.field {
                    case .id: DatabaseQueryOrder<Log.Table>(by: \.id, direction)
                    case .accountId:
                        DatabaseQueryOrder<Log.Table>(
                            by: \.accountId,
                            direction
                        )
                    case .method:
                        DatabaseQueryOrder<Log.Table>(by: \.method, direction)
                    case .source:
                        DatabaseQueryOrder<Log.Table>(by: \.source, direction)
                    case .path:
                        DatabaseQueryOrder<Log.Table>(by: \.path, direction)
                    case .responseCode:
                        DatabaseQueryOrder<Log.Table>(
                            by: \.responseCode,
                            direction
                        )
                    case .ip: DatabaseQueryOrder<Log.Table>(by: \.ip, direction)
                    case .browserName:
                        DatabaseQueryOrder<Log.Table>(
                            by: \.browserName,
                            direction
                        )
                    case .createdAt:
                        DatabaseQueryOrder<Log.Table>(
                            by: \.createdAt,
                            direction
                        )
                    }
                }
                if !query.sort.contains(where: { $0.field == .createdAt }) {
                    orders.append(.init(by: \.createdAt, .descending))
                }
                if !query.sort.contains(where: { $0.field == .id }) {
                    orders.append(.init(by: \.id, .ascending))
                }
                return result.order(by: orders).limit(page.size).offset(offset)
            }
            let total = try await accessLayer.selectCount { initial in
                var result = initial
                if let search = query.search {
                    result = result.where(
                        searchText: search,
                        columns: [DatabaseQueryTextColumn<Log.Table>(\.path)]
                    )
                }
                if let source = query.source {
                    result = result.where(\.source, equals: source)
                }
                if let method = query.method {
                    result = result.where(\.method, equals: method)
                }
                if let responseCode = query.responseCode {
                    result = result.where(\.responseCode, equals: responseCode)
                }
                if let from = query.from {
                    result = result.where(
                        \.createdAt,
                        greaterThanOrEqualTo: Date(timeIntervalSince1970: from)
                    )
                }
                if let to = query.to {
                    result = result.where(
                        \.createdAt,
                        lessThan: Date(timeIntervalSince1970: to)
                    )
                }
                return result
            }
            return .init(
                items: rows.map {
                    .init(
                        id: $0.id,
                        accountId: $0.accountId,
                        source: $0.source,
                        method: $0.method,
                        path: $0.path,
                        responseCode: $0.responseCode,
                        ip: $0.ip,
                        browserName: $0.browserName,
                        createdAt: $0.createdAt.timeIntervalSince1970
                    )
                },
                total: total
            )
        }
    }
}
