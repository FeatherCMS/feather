import Hummingbird

protocol AdminRemoveContactFormItemsPresenter: Sendable {
    func renderConfirmation(
        formId: String,
        itemId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
