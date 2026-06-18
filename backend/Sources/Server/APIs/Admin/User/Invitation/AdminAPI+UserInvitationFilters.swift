import AdminOpenAPI
import UserApplication

extension AdminAPI {

    func userInvitationFilters(
        _ input: Operations.UserInvitationFilters.Input
    ) async throws -> Operations.UserInvitationFilters.Output {
        .ok(
            .init(
                body: .json(.init())
            )
        )
    }
}
