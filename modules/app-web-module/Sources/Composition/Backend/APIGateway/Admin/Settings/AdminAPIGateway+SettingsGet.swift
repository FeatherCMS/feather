import FeatherModuleKit
public import WebAdminAPI
import WebApplication

extension AdminAPIGateway {

    public func settingsGet(
        _ input: Operations.SettingsGet.Input
    ) async throws -> Operations.SettingsGet.Output {
        let useCase = useCases.makeGetSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }
}
