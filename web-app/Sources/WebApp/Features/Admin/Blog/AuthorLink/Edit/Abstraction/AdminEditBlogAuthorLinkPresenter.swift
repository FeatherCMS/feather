import HTML

protocol AdminEditBlogAuthorLinkPresenter: Sendable {

    func renderEditPage(
        menuId: String,
        id: String,
        state: BlogAuthorLinkForm.State,
        isEdited: Bool,
        permissions: Set<String>
    ) -> HTMLResponse

    func renderErrorPage(
        menuId: String,
        id: String,
        info: String,
        message: String,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        menuId: String,
        id: String
    ) -> AdminBreadcrumb.State
}
