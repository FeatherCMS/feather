import FeatherAdmin
import Foundation

protocol AdminRemoveAuthSessionPresenter: Sendable {

    func renderPage(
        state: AuthSessionRemoveConfirmation.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorPage(
        identityId: String,
        sessionId: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        identityId: String,
        sessionId: String
    ) -> AdminBreadcrumb.State
}
