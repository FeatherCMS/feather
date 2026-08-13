import FeatherAdmin
import Foundation

protocol AdminGetUserIdentityPresenter: Sendable {

    func renderPage(
        model: AdminGetUserIdentityModel,
        permissions: Set<String>
    ) -> HTMLResponse

    func errorPage(
        id: String,
        error: OpenAPIRepositoryError,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
