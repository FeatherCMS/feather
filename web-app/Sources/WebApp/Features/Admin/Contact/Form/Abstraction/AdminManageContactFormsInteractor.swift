protocol AdminManageContactFormsInteractor: Sendable {
    func list() async throws -> [AdminManageContactFormItem]
    func create(name: String) async throws
    func get(id: String) async throws -> AdminManageContactFormItem
    func update(id: String, name: String) async throws -> AdminManageContactFormItem
    func remove(id: String) async throws
}
