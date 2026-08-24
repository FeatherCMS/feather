import AccountAdminAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AdminAPIGateway {

    public func accountSettingsGet(
        _ input: Operations.AccountSettingsGet.Input
    ) async throws -> Operations.AccountSettingsGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await useCases.makeGetSettings()
            .execute(
                subject: subject,
                input: .init()
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
