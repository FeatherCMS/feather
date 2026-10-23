import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Add {
    enum Presenter {}
}

extension Invitation.Add.Presenter {

    protocol Interface: Sendable {

        func renderPage(
            form: AccountInvitationForm.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func formState(
            email: String,
            roleIDs: [String],
            roleOptions: [AccountInvitationForm.RoleOptionState]
        ) -> AccountInvitationForm.State

        func format(
            error: OpenAPIRepositoryError
        ) -> String
    }
}
