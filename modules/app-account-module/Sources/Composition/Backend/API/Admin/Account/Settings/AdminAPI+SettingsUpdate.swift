import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountSettingsUpdate(
        _ input: Operations.AccountSettingsUpdate.Input
    ) async throws -> Operations.AccountSettingsUpdate.Output {
        let body: Components.Schemas.AccountSettingsUpdateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let subject = try await CurrentSubject.require()
        let result = try await makeEditSettings()
            .execute(
                subject: subject,
                input: .init(
                    language: body.language,
                    timezone: body.timezone,
                    pageSize: body.pageSize
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
