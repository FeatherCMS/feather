import Foundation
import Hummingbird

protocol AdminEditUserInvitationPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: UserInvitationForm.State,
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
        email: String
    ) -> UserInvitationForm.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
