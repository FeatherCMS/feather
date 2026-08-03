import Hummingbird

protocol AdminEditContactFormFieldPresenter: Sendable {
    func renderPage(
        formId: String,
        field: AdminContactFormFieldRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
