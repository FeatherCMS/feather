import FeatherAdmin
import Hummingbird

protocol AdminEditUserIdentityPresenter: Sendable {

    func renderPage(
        state: UserIdentityEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        state: UserIdentityError.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse
}
