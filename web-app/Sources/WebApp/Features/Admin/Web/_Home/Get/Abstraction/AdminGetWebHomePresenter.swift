import Hummingbird

protocol AdminGetWebHomePresenter: Sendable {

    func renderHome(
        model: AdminGetWebHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
