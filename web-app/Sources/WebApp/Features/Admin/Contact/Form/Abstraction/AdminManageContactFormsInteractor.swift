protocol AdminManageContactFormsInteractor: Sendable {
    func list() async throws -> [AdminManageContactFormItem]
    func availableFields() async throws -> [AdminManageContactFormFieldOption]
    func create(name: String, successMessage: String, failureMessage: String, redirectUrl: String?, fieldIDs: [String], mails: [AdminManageContactFormMail]) async throws -> AdminManageContactFormItem
    func get(id: String) async throws -> AdminManageContactFormItem
    func update(id: String, name: String, successMessage: String, failureMessage: String, redirectUrl: String?, fieldIDs: [String], mails: [AdminManageContactFormMail]) async throws -> AdminManageContactFormItem
    func remove(id: String) async throws
    func bulkRemove(ids: [String]) async throws
}
