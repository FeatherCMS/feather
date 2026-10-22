public import AnalyticsAdminAPI
import AnalyticsApplication
import AnalyticsDomain
import AnalyticsModule
import FeatherModuleKit

extension AdminAPIGateway {

    public func analyticsLogSearch(
        _ input: Operations.AnalyticsLogSearch.Input
    ) async throws -> Operations.AnalyticsLogSearch.Output {
        let query:
            Components.Schemas.AnalyticsLogListItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeLogSearch()
        let listQuery = map(query)
        let objectQuery = Log.Search.Input.Query(
            page: listQuery.page,
            sort: listQuery.sort.map { sort in
                let field: Log.Search.Input.Query.Sort.Field = switch sort.field {
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
                return Log.Search.Input.Query.Sort(
                    field: field,
                    direction: sort.direction
                )
            },
            search: listQuery.search,
            source: listQuery.source,
            method: listQuery.method,
            responseCode: listQuery.responseCode,
            from: listQuery.from,
            to: listQuery.to
        )
        let subject = try await CurrentSubject.require()

        let result = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let items = result.items.map(map)

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: mapResponseQuery(query),
                        data: .init(items: items, total: result.total)
                    )
                )
            )
        )
    }
}
