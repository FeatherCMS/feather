import HTML

protocol AdminEditRedirectRulePresenter: Sendable {

    func renderEditPage(
        id: String,
        state: RedirectRuleForm.State,
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
