import FeatherApplication
import FeatherContracts
import WebAdminAPI
import WebApplication

extension WebBackend {

    public func webSettingsGet(
        _ input: Operations.WebSettingsGet.Input
    ) async throws -> Operations.WebSettingsGet.Output {
        let useCase = makeGetSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }
}
