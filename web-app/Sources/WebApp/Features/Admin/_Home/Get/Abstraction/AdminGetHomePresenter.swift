import Hummingbird

protocol AdminGetHomePresenter: Sendable {

    func renderPage(
        model: AdminGetHomeModel
    ) -> HTMLResponse
}
