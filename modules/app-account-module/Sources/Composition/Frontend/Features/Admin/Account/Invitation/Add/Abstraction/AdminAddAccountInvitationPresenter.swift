import FeatherAdmin
import Foundation
import Hummingbird

protocol AdminAddAccountInvitationPresenter: Sendable {

    func renderPage(
        form: AccountInvitationForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func formState(
        email: String
    ) -> AccountInvitationForm.State

    func breadcrumb() -> AdminBreadcrumb.State

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
