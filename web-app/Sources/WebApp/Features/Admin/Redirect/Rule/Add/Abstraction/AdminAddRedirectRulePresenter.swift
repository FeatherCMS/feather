import Hummingbird

protocol AdminAddRedirectRulePresenter: Sendable {

    func renderAddPage(
        state: RedirectRuleForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
