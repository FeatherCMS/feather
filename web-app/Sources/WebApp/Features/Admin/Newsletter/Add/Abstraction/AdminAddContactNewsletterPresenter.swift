import Hummingbird

protocol AdminAddContactNewsletterPresenter: Sendable {
    func renderPage(model: AdminAddContactNewsletterModel, permissions: Set<String>) -> HTMLResponse
}
