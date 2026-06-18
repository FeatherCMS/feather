import Foundation
import Hummingbird

protocol AdminGetAuthMagicLinkPresenter: Sendable {

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State

    func renderPage(
        link: AuthMagicLinkDetailsModel,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse
}
