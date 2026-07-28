import Hummingbird

protocol AdminEditContactFormItemsPresenter: Sendable {
    func renderPage(
        formId: String,
        item: AdminContactFormItemRow,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
