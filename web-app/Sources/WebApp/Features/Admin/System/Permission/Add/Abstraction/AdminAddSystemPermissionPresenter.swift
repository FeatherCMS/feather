import Hummingbird

protocol AdminAddSystemPermissionPresenter: Sendable {

    func renderAddPage(
        state: SystemPermissionForm.State,
        permissions: Set<String>
    ) -> HTMLResponse
}
