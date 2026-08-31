import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminAddAccountInvitationPresenter: Sendable {

    func renderPage(
        form: AccountInvitationForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        email: String,
        roleIDs: [String],
        roleOptions: [AccountInvitationForm.RoleOptionState]
    ) -> AccountInvitationForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
