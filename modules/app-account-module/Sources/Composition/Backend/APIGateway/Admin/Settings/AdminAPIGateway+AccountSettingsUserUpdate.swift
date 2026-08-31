import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func adminAccountSettingsUpdate(
        _ input: Operations.AdminAccountSettingsUpdate.Input
    ) async throws -> Operations.AdminAccountSettingsUpdate.Output {
        let body: Components.Schemas.AccountSettingsUpdateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeEditSettings().execute(
            subject: subject,
            input: .init(
                language: body.language,
                timezone: body.timezone,
                pageSize: body.pageSize,
                userId: input.path.userId
            )
        )
        return .ok(
            .init(
                body: .json(
                    .init(
                        language: result.language,
                        timezone: result.timezone,
                        pageSize: result.pageSize
                    )
                )
            )
        )
    }
}
