import AnalyticsAdminAPI
import AnalyticsApplication
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation

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
        _ page: Components.Schemas.SearchPageSchema
    ) -> Search.Page {
        .init(size: page.size, number: page.number)
    }

    func map(
        _ query: Components.Schemas.AnalyticsLogListItemSearchQuerySchema
    ) -> LogList.Query {
        let sort = (query.sort ?? [])
            .map { item in
                let field: LogList.Query.Sort.Field
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
                return LogList.Query.Sort(
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
            responseCode: query.filters.responseCode
        )
    }

    func map(
        _ item: LogList.Item
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
    ) -> LogOverview.Query {
        .init(source: query.source, from: query.from, to: query.to)
    }

    func map(
        _ item: LogOverview.BreakdownItem
    ) -> Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema {
        .init(label: item.label, count: item.count, share: item.share)
    }

    func map(
        _ item: LogOverview.DailyPoint
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
        _ overview: LogOverview
    ) -> Components.Schemas.AnalyticsLogOverviewSchema {
        .init(
            query: .init(
                source: overview.query.source,
                from: overview.query.from,
                to: overview.query.to
            ),
            kpis: .init(
                totalRequests: overview.kpis.totalRequests,
                averageRequestsPerDay: overview.kpis.averageRequestsPerDay,
                authenticatedRequests: overview.kpis.authenticatedRequests,
                notFoundRequests: overview.kpis.notFoundRequests,
                clientErrorRequests: overview.kpis.clientErrorRequests,
                serverErrorRequests: overview.kpis.serverErrorRequests
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
        _ detail: LogDetail
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
