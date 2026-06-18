import HTML

protocol AdminEditSystemVariablePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: SystemVariableForm.State,
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
