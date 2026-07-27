import Hummingbird

protocol AdminGetContactFormPresenter: Sendable {
    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
