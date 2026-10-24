public import AnalyticsAdminAPI
import AnalyticsApplication
import AnalyticsDomain
import AnalyticsModule
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
}
