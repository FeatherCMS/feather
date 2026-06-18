import Foundation
import Hummingbird

protocol AdminAddUserInvitationPresenter: Sendable {

    func renderPage(
        form: UserInvitationForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        email: String
    ) -> UserInvitationForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
