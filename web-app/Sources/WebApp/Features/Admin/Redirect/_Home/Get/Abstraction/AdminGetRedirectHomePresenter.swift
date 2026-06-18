import Hummingbird

protocol AdminGetRedirectHomePresenter: Sendable {

    func renderHome(
        model: AdminGetRedirectHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
