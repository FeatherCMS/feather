import Hummingbird

protocol AdminAddBlogPostPresenter: Sendable {

    func renderAddPage(
        state: BlogPostForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
