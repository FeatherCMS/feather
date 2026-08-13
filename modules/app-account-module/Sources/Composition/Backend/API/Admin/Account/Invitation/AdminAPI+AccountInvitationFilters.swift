import AccountAdminAPI
import AccountApplication

extension AccountBackend {

    public func accountInvitationFilters(
        _ input: Operations.AccountInvitationFilters.Input
    ) async throws -> Operations.AccountInvitationFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
