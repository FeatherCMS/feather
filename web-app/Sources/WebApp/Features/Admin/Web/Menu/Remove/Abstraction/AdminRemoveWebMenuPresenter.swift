import Hummingbird

protocol AdminRemoveWebMenuPresenter: Sendable {

    func renderRemovePage(
        id: String,
        source: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        id: String
    ) -> AdminBreadcrumb.State
}
