import Hummingbird

protocol AdminAddWebPagePresenter: Sendable {

    func renderAddPage(
        state: WebPageForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
