import AccountApplication
import AdminOpenAPI
import Application

extension AdminAPI {

    func accountSettingsGet(
        _ input: Operations.AccountSettingsGet.Input
    ) async throws -> Operations.AccountSettingsGet.Output {
        let useCase = modules.account.makeGetAccountSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init()
        )

        return .ok(.init(body: .json(map(result))))
    }
}
