import Hummingbird

protocol AdminRemoveContactFieldPresenter: Sendable {
    func renderConfirmation(
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
