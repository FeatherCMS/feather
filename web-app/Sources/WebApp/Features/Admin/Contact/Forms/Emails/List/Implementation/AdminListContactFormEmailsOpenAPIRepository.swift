import AdminOpenAPI

struct AdminListContactFormEmailsOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminGetContactFormOpenAPIRepository(api: api).get(id: id)
    }
}
