import AnalyticsAdminAPI
import AnalyticsApplication
import FeatherApplication
import FeatherContracts

extension AnalyticsBackend {

    public func analyticsLogGet(
        _ input: Operations.AnalyticsLogGet.Input
    ) async throws -> Operations.AnalyticsLogGet.Output {
        let useCase = makeGetLog()
        let subject = try await CurrentSubject.require()
        let detail = try await useCase.execute(
            subject: subject,
            input: .init(id: input.path.id)
        )
        return .ok(
            .init(
                body: .json(map(detail))
            )
        )
    }
}
