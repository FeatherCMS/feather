import Hummingbird

protocol AdminAddWebMenuPresenter: Sendable {

    func renderAddPage(
        state: WebMenuForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
