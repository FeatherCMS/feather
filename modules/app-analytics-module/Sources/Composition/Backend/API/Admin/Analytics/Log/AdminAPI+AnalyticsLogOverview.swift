import AnalyticsAdminAPI
import AnalyticsApplication
import FeatherApplication
import FeatherContracts

extension AnalyticsBackend {

    public func analyticsLogOverview(
        _ input: Operations.AnalyticsLogOverview.Input
    ) async throws -> Operations.AnalyticsLogOverview.Output {
        let query: Components.Schemas.AnalyticsLogOverviewQuerySchema
        switch input.body {
        case .json(let value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let overview = try await makeGetLogOverview()
            .execute(
                subject: subject,
                input: .init(query: map(query))
            )

        return .ok(
            .init(
                body: .json(
                    map(overview)
                )
            )
        )
    }
}
