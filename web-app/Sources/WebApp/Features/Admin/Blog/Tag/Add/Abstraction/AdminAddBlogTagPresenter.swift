import Hummingbird

protocol AdminAddBlogTagPresenter: Sendable {

    func renderAddPage(
        state: BlogTagForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
