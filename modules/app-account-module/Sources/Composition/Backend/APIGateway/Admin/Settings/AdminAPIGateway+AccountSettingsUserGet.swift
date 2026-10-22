public import AccountAdminAPI
import AccountApplication
import FeatherModuleKit

extension AdminAPIGateway {

    public func accountUserSettingsGet(
        _ input: Operations.AccountUserSettingsGet.Input
    ) async throws -> Operations.AccountUserSettingsGet.Output {
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
