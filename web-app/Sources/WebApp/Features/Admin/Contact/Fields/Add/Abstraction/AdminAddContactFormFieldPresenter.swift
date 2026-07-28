import Hummingbird

protocol AdminAddContactFormFieldPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFormFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
