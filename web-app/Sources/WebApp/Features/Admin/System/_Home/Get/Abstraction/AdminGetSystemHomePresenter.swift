import Hummingbird

protocol AdminGetSystemHomePresenter: Sendable {

    func renderHome(
        model: AdminGetSystemHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
