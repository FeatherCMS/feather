import Hummingbird

protocol AdminListContactFormItemsPresenter: Sendable {
    func renderList(
        formId: String,
        items: [AdminContactFormItemRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
