import AnalyticsApplication
import Application
import AdminOpenAPI

extension AdminAPI {

    func redirectNotFoundOverview(
        _ input: Operations.RedirectNotFoundOverview.Input
    ) async throws -> Operations.RedirectNotFoundOverview.Output {
        let query: Components.Schemas.AnalyticsLogOverviewQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let subject = try await CurrentSubject.require()
        let overview = try await modules.redirect.makeGetNotFoundOverview()
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
