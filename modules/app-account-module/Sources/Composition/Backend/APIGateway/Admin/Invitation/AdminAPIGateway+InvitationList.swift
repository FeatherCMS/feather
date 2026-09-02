import AccountAdminAPI
import AccountApplication

extension AdminAPIGateway {

    public func accountInvitationList(
        _ input: Operations.AccountInvitationList.Input
    ) async throws -> Operations.AccountInvitationList.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
