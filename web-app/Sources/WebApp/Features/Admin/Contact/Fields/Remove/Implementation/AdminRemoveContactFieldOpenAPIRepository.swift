import AdminOpenAPI

struct AdminRemoveContactFieldOpenAPIRepository {
    let api: AdminAPI

    func get(id: String) async throws -> AdminContactFieldRow {
        try await AdminListContactFieldsOpenAPIRepository(api: api)
            .list().first { $0.id == id }
            ?? {
                throw OpenAPIRepositoryError.notFound(
                    message: "This contact field could not be found."
                )
            }()
    }

    func remove(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            switch try await client.contactFieldDelete(
                path: .init(contactFormItemId: id)
            ) {
            case .noContent: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This contact field could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete contact fields."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete contact fields."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
    func bulkRemove(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.contactFieldBulkDelete(
                body: .json(.init(ids: ids, summary: true))
            )
        }
    }
}
