import Hummingbird

protocol AdminAddWebMenuItemPresenter: Sendable {

    func renderAddPage(
        menuId: String,
        state: WebMenuItemForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb(
        menuId: String
    ) -> AdminBreadcrumb.State
}
