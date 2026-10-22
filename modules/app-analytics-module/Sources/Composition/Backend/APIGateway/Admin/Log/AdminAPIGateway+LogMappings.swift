import AnalyticsAdminAPI
import AnalyticsApplication
import AnalyticsDomain
import AnalyticsModule
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {

    func mapSortDirection(
        _ direction: Components.Schemas.SortDirection
    ) -> Search.SortDirection {
        switch direction {
        case .asc:
            .asc
        case .desc:
            .desc
        }
    }

    func map(
        _ page: Components.Schemas.SearchPageSchema?
    ) -> Search.Page {
        .init(size: page?.size ?? 20, number: page?.number ?? 1)
    }

    func mapResponseQuery(
        _ query: Components.Schemas.AnalyticsLogListItemSearchRequestQuerySchema
    ) -> Components.Schemas.AnalyticsLogListItemSearchResponseQuerySchema {
        let page = map(query.page).normalized()
        return .init(
            page: .init(size: page.size, number: page.number),
            sort: query.sort?
                .map { item in
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

    func map(
        _ query: Components.Schemas.AnalyticsLogListItemSearchRequestQuerySchema
    ) -> Log.List.Input.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: Log.List.Input.Query.Sort.Field
                switch item.field {
                case .id:
                    field = .id
                case .accountId:
                    field = .accountId
                case .method:
                    field = .method
                case .source:
                    field = .source
                case .path:
                    field = .path
                case .responseCode:
                    field = .responseCode
                case .ip:
                    field = .ip
                case .browserName:
                    field = .browserName
                case .createdAt:
                    field = .createdAt
                }
                return Log.List.Input.Query.Sort(
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

    func map(
        _ item: Log.List.Output.Item
    ) -> Components.Schemas.AnalyticsLogListItemSchema {
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

    func map(
        _ item: Log.Search.Output.Item
    ) -> Components.Schemas.AnalyticsLogListItemSchema {
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

    func map(
        _ query: Components.Schemas.AnalyticsLogOverviewQuerySchema
    ) -> Log.Overview.Input.Query {
        .init(
            source: query.source,
            from: query.from,
            to: query.to,
            dashboardOnly: query.dashboardOnly ?? false,
            notFoundOnly: query.notFoundOnly ?? false
        )
    }

    func map(
        _ item: Log.Overview.Output.BreakdownItem
    ) -> Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema {
        .init(label: item.label, count: item.count, share: item.share)
    }

    func map(
        _ item: Log.Overview.Output.DailyPoint
    ) -> Components.Schemas.AnalyticsLogOverviewDailyPointSchema {
        .init(
            bucket: item.bucket,
            requests: item.requests,
            notFoundRequests: item.notFoundRequests,
            clientErrorRequests: item.clientErrorRequests,
            serverErrorRequests: item.serverErrorRequests
        )
    }

    func map(
        _ overview: Log.Overview.Output,
        query: Log.Overview.Input.Query
    ) -> Components.Schemas.AnalyticsLogOverviewSchema {
        .init(
            query: .init(
                source: query.source,
                from: query.from,
                to: query.to
            ),
            kpis: .init(
                totalRequests: overview.kpis.totalRequests,
                averageRequestsPerDay: overview.kpis.averageRequestsPerDay,
                authenticatedRequests: overview.kpis.authenticatedRequests,
                notFoundRequests: overview.kpis.notFoundRequests,
                clientErrorRequests: overview.kpis.clientErrorRequests,
                serverErrorRequests: overview.kpis.serverErrorRequests,
                pageViews: overview.kpis.pageViews,
                searchRequests: overview.kpis.searchRequests,
                botRequests: overview.kpis.botRequests,
                aiRequests: overview.kpis.aiRequests,
                humanRequests: overview.kpis.humanRequests,
                uniqueVisitors: overview.kpis.uniqueVisitors
            ),
            daily: overview.daily.map(map),
            statusFamilies: overview.statusFamilies.map(map),
            methods: overview.methods.map(map),
            paths: overview.paths.map(map),
            notFoundPaths: overview.notFoundPaths.map(map),
            serverErrorPaths: overview.serverErrorPaths.map(map),
            referrers: overview.referrers.map(map),
            browsers: overview.browsers.map(map),
            operatingSystems: overview.operatingSystems.map(map),
            deviceTypes: overview.deviceTypes.map(map),
            languages: overview.languages.map(map),
            regions: overview.regions.map(map)
        )
    }

    func map(
        _ detail: Log.Detail.Output
    ) -> Components.Schemas.AnalyticsLogDetailSchema {
        .init(
            id: detail.id,
            accountId: detail.accountId ?? "",
            source: detail.source,
            method: detail.method,
            url: detail.url,
            headers: detail.headers,
            ip: detail.ip ?? "",
            path: detail.path,
            referer: detail.referer ?? "",
            origin: detail.origin ?? "",
            acceptLanguage: detail.acceptLanguage ?? "",
            userAgent: detail.userAgent ?? "",
            language: detail.language ?? "",
            region: detail.region ?? "",
            osName: detail.osName ?? "",
            osVersion: detail.osVersion ?? "",
            browserName: detail.browserName ?? "",
            browserVersion: detail.browserVersion ?? "",
            engineName: detail.engineName ?? "",
            engineVersion: detail.engineVersion ?? "",
            deviceVendor: detail.deviceVendor ?? "",
            deviceType: detail.deviceType ?? "",
            deviceModel: detail.deviceModel ?? "",
            cpu: detail.cpu ?? "",
            responseCode: detail.responseCode,
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt
        )
    }
}
