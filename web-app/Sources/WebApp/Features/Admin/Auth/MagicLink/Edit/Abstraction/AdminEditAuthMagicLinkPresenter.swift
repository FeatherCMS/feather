import Foundation
import Hummingbird

protocol AdminEditAuthMagicLinkPresenter: Sendable {

    func formState(
        email: String,
        isPersistent: Bool
    ) -> AuthMagicLinkForm.State

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderPage(
        id: String,
        isEdited: Bool,
        form: AuthMagicLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func format(
        error: OpenAPIRepositoryError
    ) -> String
}
