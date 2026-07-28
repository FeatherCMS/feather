import Hummingbird

protocol AdminListContactFormFieldsPresenter: Sendable {
    func renderList(
        formId: String,
        fields: [AdminContactFormFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
