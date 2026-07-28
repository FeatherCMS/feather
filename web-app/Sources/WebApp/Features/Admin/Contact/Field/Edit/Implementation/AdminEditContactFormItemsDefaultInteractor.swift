struct AdminEditContactFormItemsDefaultInteractor:
    AdminEditContactFormItemsInteractor
{
    let repository: AdminEditContactFormItemsOpenAPIRepository
    func get(formId: String, id: String) async throws -> AdminContactFormItemRow
    { try await repository.get(formId: formId, id: id) }
    func update(formId: String, id: String, form: ContactFormItemAddForm)
        async throws
    { try await repository.update(formId: formId, id: id, form: form) }
}
