import FeatherAdmin
import Foundation

protocol AdminRemoveUserIdentityPresenter: Sendable {

    func renderPage(
        state: UserIdentityConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorState(
        id: String,
        error: OpenAPIRepositoryError
    ) -> UserIdentityError.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
