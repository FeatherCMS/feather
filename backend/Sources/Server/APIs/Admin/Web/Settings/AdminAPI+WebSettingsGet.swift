import AdminOpenAPI
import WebApplication
import Application

extension AdminAPI {

    func webSettingsGet(
        _ input: Operations.WebSettingsGet.Input
    ) async throws -> Operations.WebSettingsGet.Output {
        let useCase = modules.web.makeGetSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }
}
