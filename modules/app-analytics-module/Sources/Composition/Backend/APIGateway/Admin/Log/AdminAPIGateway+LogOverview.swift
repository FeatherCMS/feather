public import AnalyticsAdminAPI
import AnalyticsApplication
import AnalyticsModule
import FeatherModuleKit

extension AdminAPIGateway {

    public func analyticsLogOverview(
        _ input: Operations.AnalyticsLogOverview.Input
    ) async throws -> Operations.AnalyticsLogOverview.Output {
        let query: Components.Schemas.AnalyticsLogOverviewQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let overviewQuery = map(query)
        let overview = try await useCases.makeLogOverview()
            .execute(
                subject: subject,
                input: .init(query: overviewQuery)
            )

        return .ok(
            .init(
                body: .json(
                    map(overview, query: overviewQuery)
                )
            )
        )
    }

    private func map(
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

    private func map(
        _ item: Log.Overview.Output.BreakdownItem
    ) -> Components.Schemas.AnalyticsLogOverviewBreakdownItemSchema {
        .init(label: item.label, count: item.count, share: item.share)
    }

    private func map(
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

    private func map(
        _ overview: Log.Overview.Output,
        query: Log.Overview.Input.Query
    ) -> Components.Schemas.AnalyticsLogOverviewSchema {
        .init(
            query: .init(source: query.source, from: query.from, to: query.to),
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
}
