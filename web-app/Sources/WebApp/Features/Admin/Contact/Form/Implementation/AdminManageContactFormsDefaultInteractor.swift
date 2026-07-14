struct AdminManageContactFormsDefaultInteractor: AdminManageContactFormsInteractor {
    let repository: AdminManageContactFormsOpenAPIRepository
    func list() async throws -> [AdminManageContactFormItem] { try await repository.list() }
    func availableFields() async throws -> [AdminManageContactFormFieldOption] { try await repository.availableFields() }
    func create(name: String, successMessage: String, failureMessage: String, redirectUrl: String?, fieldIDs: [String], mails: [AdminManageContactFormMail]) async throws -> AdminManageContactFormItem {
        try await repository.create(name: name, successMessage: successMessage, failureMessage: failureMessage, redirectUrl: redirectUrl, fieldIDs: fieldIDs, mails: mails)
    }
    func get(id: String) async throws -> AdminManageContactFormItem { try await repository.get(id: id) }
    func update(id: String, name: String, successMessage: String, failureMessage: String, redirectUrl: String?, fieldIDs: [String], mails: [AdminManageContactFormMail]) async throws -> AdminManageContactFormItem { try await repository.update(id: id, name: name, successMessage: successMessage, failureMessage: failureMessage, redirectUrl: redirectUrl, fieldIDs: fieldIDs, mails: mails) }
    func remove(id: String) async throws { try await repository.remove(id: id) }
    func bulkRemove(ids: [String]) async throws {
        for id in ids { try await repository.remove(id: id) }
    }
}
