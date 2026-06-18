import AnalyticsApplication
import Application
import AdminOpenAPI

extension AdminAPI {

    func analyticsLogGet(
        _ input: Operations.AnalyticsLogGet.Input
    ) async throws -> Operations.AnalyticsLogGet.Output {
        let useCase = modules.analytics.makeGetLog()
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
