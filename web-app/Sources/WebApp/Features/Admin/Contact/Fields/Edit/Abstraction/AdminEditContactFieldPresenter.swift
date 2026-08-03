import Hummingbird

protocol AdminEditContactFieldPresenter: Sendable {
    func renderPage(
        field: AdminContactFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
