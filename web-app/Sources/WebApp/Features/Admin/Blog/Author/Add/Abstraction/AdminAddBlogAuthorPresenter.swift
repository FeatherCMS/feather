import Hummingbird

protocol AdminAddBlogAuthorPresenter: Sendable {

    func renderAddPage(
        state: BlogAuthorForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
