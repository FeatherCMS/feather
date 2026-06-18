import Hummingbird

protocol AdminEditSystemPermissionPresenter: Sendable {

    func renderEditPage(
        id: String,
        state: SystemPermissionForm.State,
        isEdited: Bool,
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
