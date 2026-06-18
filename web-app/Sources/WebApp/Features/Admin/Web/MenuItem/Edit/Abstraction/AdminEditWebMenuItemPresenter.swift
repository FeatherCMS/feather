import HTML

protocol AdminEditWebMenuItemPresenter: Sendable {

    func renderEditPage(
        menuId: String,
        id: String,
        state: WebMenuItemForm.State,
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
