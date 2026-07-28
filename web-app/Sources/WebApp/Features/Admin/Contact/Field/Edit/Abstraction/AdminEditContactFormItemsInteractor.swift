protocol AdminEditContactFormItemsInteractor: Sendable {
    func get(formId: String, id: String) async throws -> AdminContactFormItemRow
    func update(formId: String, id: String, form: ContactFormItemAddForm)
        async throws
}
