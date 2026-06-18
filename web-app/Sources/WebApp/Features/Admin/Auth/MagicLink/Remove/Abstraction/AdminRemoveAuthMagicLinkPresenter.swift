import Foundation
import Hummingbird

protocol AdminRemoveAuthMagicLinkPresenter: Sendable {

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderPage(
        id: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse
}
