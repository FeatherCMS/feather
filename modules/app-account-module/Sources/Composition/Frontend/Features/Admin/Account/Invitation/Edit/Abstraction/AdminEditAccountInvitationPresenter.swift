import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminEditAccountInvitationPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: AccountInvitationForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        email: String,
        roleIDs: [String],
        roleOptions: [AccountInvitationForm.RoleOptionState]
    ) -> AccountInvitationForm.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
