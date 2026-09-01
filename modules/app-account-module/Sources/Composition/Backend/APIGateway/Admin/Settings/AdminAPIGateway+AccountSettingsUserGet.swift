import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func adminAccountSettingsGet(
        _ input: Operations.AdminAccountSettingsGet.Input
    ) async throws -> Operations.AdminAccountSettingsGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetSettings()
            .execute(
                subject: subject,
                input: .init(userId: input.path.userId)
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
