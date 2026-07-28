import Hummingbird

protocol AdminRemoveContactFormFieldPresenter: Sendable {
    func renderConfirmation(
        formId: String,
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse
    func renderBulkConfirmation(formId: String, selectedIds: [String], permissions: Set<String>)
        -> HTMLResponse
}
