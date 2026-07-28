import Hummingbird

protocol AdminGetAccountHomePresenter: Sendable {

    func renderHome(
        model: AdminGetAccountHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
