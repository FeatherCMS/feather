import Hummingbird

protocol AdminAddContactFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
