import AccountApplication
import AdminOpenAPI
import Application

extension AdminAPI {

    func accountSettingsUpdate(
        _ input: Operations.AccountSettingsUpdate.Input
    ) async throws -> Operations.AccountSettingsUpdate.Output {
        let body: Components.Schemas.AccountSettingsUpdateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.account.makeEditAccountSettings()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                language: body.language,
                timezone: body.timezone,
                pageSize: body.pageSize
            )
        )

        return .ok(.init(body: .json(map(result))))
    }
}
