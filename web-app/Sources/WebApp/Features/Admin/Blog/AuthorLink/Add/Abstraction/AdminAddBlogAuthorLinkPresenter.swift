import Hummingbird

protocol AdminAddBlogAuthorLinkPresenter: Sendable {

    func renderAddPage(
        menuId: String,
        state: BlogAuthorLinkForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        menuId: String
    ) -> AdminBreadcrumb.State
}
