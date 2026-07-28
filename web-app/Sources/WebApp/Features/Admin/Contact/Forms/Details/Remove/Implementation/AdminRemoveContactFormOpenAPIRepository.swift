import AdminOpenAPI

struct AdminRemoveContactFormOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminGetContactFormOpenAPIRepository(api: api).get(id: id)
    }
    func bulkRemove(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFormBulkDelete(
                body: .json(.init(ids: ids, summary: true))
            )
        }
    }
}
