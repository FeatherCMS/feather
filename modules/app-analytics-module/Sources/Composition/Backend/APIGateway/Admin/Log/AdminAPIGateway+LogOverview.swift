public import AnalyticsAdminAPI
import AnalyticsApplication
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
}
