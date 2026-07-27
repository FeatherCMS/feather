import Hummingbird

protocol AdminAddContactFormItemPresenter: Sendable {
    func renderPage(
        model: AdminAddContactFormItemModel,
        permissions: Set<String>
    ) -> HTMLResponse
}
