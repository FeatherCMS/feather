import Hummingbird

protocol AdminEditUserAccountPresenter: Sendable {

    func renderPage(
        state: UserAccountEdit.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderError(
        state: UserAccountError.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderDeniedPage(
        breadcrumb: AdminBreadcrumb.State,
        permissions: Set<String>
    ) -> HTMLResponse
}
