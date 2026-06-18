import Hummingbird

protocol AdminGetUserHomePresenter: Sendable {

    func renderPage(
        model: AdminGetUserHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
