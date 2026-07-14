struct AdminManageContactFormItemsDefaultInteractor: AdminManageContactFormItemsInteractor {
    let repository: AdminManageContactFormItemsOpenAPIRepository
    func list(formId: String) async throws -> [AdminManageContactFormItemRow] { try await repository.list(formId: formId) }
    func get(formId: String, id: String) async throws -> AdminManageContactFormItemRow { try await repository.get(formId: formId, id: id) }
    func update(formId: String, id: String, form: ContactFormItemAddForm) async throws { try await repository.update(formId: formId, id: id, form: form) }
    func remove(formId: String, id: String) async throws { try await repository.remove(formId: formId, id: id) }
    func bulkRemove(formId: String, ids: [String]) async throws { for id in ids { try await repository.remove(formId: formId, id: id) } }
}
