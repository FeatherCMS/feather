public import AnalyticsAdminAPI
import AnalyticsApplication
import AnalyticsDomain
import AnalyticsModule
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func analyticsLogQuery(
        _ input: Operations.AnalyticsLogQuery.Input
    ) async throws -> Operations.AnalyticsLogQuery.Output {
        let query:
            Components.Schemas.AnalyticsLogQueryItemSearchRequestQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let useCase = useCases.makeLogSearch()
        let objectQuery = map(query)
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

    private func mapSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc: .asc
        case .desc: .desc
        }
    }

    private func map(
        _ page: Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        .init(size: page?.size ?? 20, number: page?.number ?? 1)
    }

    private func mapResponseQuery(
        _ query: Components.Schemas.AnalyticsLogQueryItemSearchRequestQuerySchema
    ) -> Components.Schemas.AnalyticsLogQueryItemSearchResponseQuerySchema {
        let page = map(query.page).normalized()
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: query.sort?.map { item in
                .init(
                    field: .init(rawValue: item.field.rawValue) ?? .id,
                    direction: item.direction
                )
            },
            filters: .init(
                search: query.filters.search,
                source: query.filters.source,
                method: query.filters.method,
                responseCode: query.filters.responseCode,
                from: query.filters.from,
                to: query.filters.to
            )
        )
    }

    private func map(
        _ query: Components.Schemas.AnalyticsLogQueryItemSearchRequestQuerySchema
    ) -> Log.Search.Input.Query {
        let sort = (query.sort ?? []).map { item in
            let field: Log.Search.Input.Query.Sort.Field
            switch item.field {
            case .id: field = .id
            case .accountId: field = .accountId
            case .method: field = .method
            case .source: field = .source
            case .path: field = .path
            case .responseCode: field = .responseCode
            case .ip: field = .ip
            case .browserName: field = .browserName
            case .createdAt: field = .createdAt
            }
            return Log.Search.Input.Query.Sort(
                field: field,
                direction: mapSortDirection(item.direction)
            )
        }

        return .init(
            page: map(query.page),
            sort: sort,
            search: (query.filters.search ?? "").emptyToNil,
            source: (query.filters.source ?? "").emptyToNil,
            method: (query.filters.method ?? "").emptyToNil,
            responseCode: query.filters.responseCode,
            from: query.filters.from,
            to: query.filters.to
        )
    }

    private func map(
        _ item: Log.Search.Output.Item
    ) -> Components.Schemas.AnalyticsLogQueryItemSchema {
        .init(
            id: item.id,
            accountId: item.accountId ?? "",
            source: item.source,
            method: item.method,
            path: item.path,
            responseCode: item.responseCode,
            ip: item.ip ?? "",
            browserName: item.browserName ?? "",
            createdAt: item.createdAt
        )
    }
}
