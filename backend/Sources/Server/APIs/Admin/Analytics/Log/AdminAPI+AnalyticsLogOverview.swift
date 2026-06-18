import AnalyticsApplication
import Application
import AdminOpenAPI

extension AdminAPI {

    func analyticsLogOverview(
        _ input: Operations.AnalyticsLogOverview.Input
    ) async throws -> Operations.AnalyticsLogOverview.Output {
        let query: Components.Schemas.AnalyticsLogOverviewQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let overview = try await modules.analytics.makeGetLogOverview()
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
