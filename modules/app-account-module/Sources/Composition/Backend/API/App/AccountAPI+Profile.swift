import AccountAppAPI
import AccountApplication
import FeatherApplication
import FeatherContracts

extension AccountBackend {

    public func accountSettings(
        _ input: Operations.AccountSettings.Input
    ) async throws -> Operations.AccountSettings.Output {
        let subject = try await CurrentSubject.require()
        let result = try await makeGetSettings()
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
