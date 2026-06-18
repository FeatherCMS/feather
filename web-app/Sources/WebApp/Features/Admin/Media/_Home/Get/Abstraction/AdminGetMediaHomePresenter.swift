import Hummingbird

protocol AdminGetMediaHomePresenter: Sendable {

    func renderPage(
        model: AdminGetMediaHomeModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
