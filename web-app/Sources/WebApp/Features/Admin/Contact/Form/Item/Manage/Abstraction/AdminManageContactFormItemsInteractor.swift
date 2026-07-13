protocol AdminManageContactFormItemsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminManageContactFormItemRow]
    func get(formId: String, id: String) async throws -> AdminManageContactFormItemRow
    func update(formId: String, id: String, form: ContactFormItemAddForm) async throws
    func remove(formId: String, id: String) async throws
}
