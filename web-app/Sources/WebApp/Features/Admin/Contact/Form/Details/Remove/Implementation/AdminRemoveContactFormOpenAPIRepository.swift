import AdminOpenAPI

struct AdminRemoveContactFormOpenAPIRepository {
    let api: AdminAPI
    func get(id: String) async throws -> AdminContactFormDetailsItem {
        try await AdminGetContactFormOpenAPIRepository(api: api).get(id: id)
    }
    func remove(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormDelete(
                path: .init(contactFormId: id)
            )
            switch response {
            case .noContent: return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete contact forms."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete contact forms."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This contact form could not be found."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
