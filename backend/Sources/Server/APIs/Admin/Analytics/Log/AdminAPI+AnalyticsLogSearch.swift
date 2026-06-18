import AnalyticsApplication
import Application
import AdminOpenAPI

extension AdminAPI {

    func analyticsLogSearch(
        _ input: Operations.AnalyticsLogSearch.Input
    ) async throws -> Operations.AnalyticsLogSearch.Output {
        let query: Components.Schemas.AnalyticsLogListItemSearchQuerySchema
        switch input.body {
        case let .json(value):
            query = value
        }

        let useCase = modules.analytics.makeListLogs()
        let objectQuery = map(query)
        let subject = try await CurrentSubject.require()

        let list = try await useCase.execute(
            subject: subject,
            input: .init(query: objectQuery)
        )
        let total = try await useCase.count(
            subject: subject,
            input: .init(query: objectQuery)
        )

        let items = list.items.map(map)

        return .ok(
            .init(
                body: .json(
                    .init(
                        query: query,
                        data: .init(items: items, total: total)
                    )
                )
            )
        )
    }
}
