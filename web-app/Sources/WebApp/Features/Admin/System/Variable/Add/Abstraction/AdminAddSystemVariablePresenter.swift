import Hummingbird

protocol AdminAddSystemVariablePresenter: Sendable {

    func renderAddPage(
        state: SystemVariableForm.State,
        permissions: Set<String>
    ) -> HTMLResponse

    func breadcrumb() -> AdminBreadcrumb.State
}
