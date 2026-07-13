struct AdminManageContactFormsDefaultInteractor: AdminManageContactFormsInteractor {
    let repository: AdminManageContactFormsOpenAPIRepository
    func list() async throws -> [AdminManageContactFormItem] { try await repository.list() }
    func create(name: String) async throws { _ = try await repository.create(name: name) }
    func get(id: String) async throws -> AdminManageContactFormItem { try await repository.get(id: id) }
    func update(id: String, name: String) async throws -> AdminManageContactFormItem { try await repository.update(id: id, name: name) }
    func remove(id: String) async throws { try await repository.remove(id: id) }
}
