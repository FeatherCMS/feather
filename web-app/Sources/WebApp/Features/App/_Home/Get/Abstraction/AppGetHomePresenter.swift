import Hummingbird

protocol AppGetHomePresenter: Sendable {
    func renderPage(
        model: AppGetHomeModel
    ) -> HTMLResponse

}
