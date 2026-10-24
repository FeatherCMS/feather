import AnalyticsApplication
import AnalyticsModule
import FeatherDatabase
import FeatherInfrastructure

extension Log.Search.Query {
    public struct Database: Interface {
        private let queries: LogDatabaseQueries

        public init(context: DatabaseQueryContext) {
            self.queries = LogDatabaseQueries(context: context)
        }

        public func search(query: Log.Search.Input.Query) async throws
            -> Log.Search.Output
        {
            let listQuery = Log.List.Input.Query(
                page: query.page,
                sort: query.sort.map { sort in
                    let field: Log.List.Input.Query.Sort.Field = switch sort.field {
                    case .id: .id
                    case .accountId: .accountId
                    case .method: .method
                    case .source: .source
                    case .path: .path
                    case .responseCode: .responseCode
                    case .ip: .ip
                    case .browserName: .browserName
                    case .createdAt: .createdAt
                    }
                    return Log.List.Input.Query.Sort(
                        field: field,
                        direction: sort.direction
                    )
                },
                search: query.search,
                source: query.source,
                method: query.method,
                responseCode: query.responseCode,
                from: query.from,
                to: query.to
            )
            let result = try await queries.list(query: listQuery)
            let total = try await queries.count(query: listQuery)
            return .init(
                items: result.items.map {
                    .init(
                        id: $0.id,
                        accountId: $0.accountId,
                        source: $0.source,
                        method: $0.method,
                        path: $0.path,
                        responseCode: $0.responseCode,
                        ip: $0.ip,
                        browserName: $0.browserName,
                        createdAt: $0.createdAt
                    )
                },
                total: total
            )
        }
    }
}
