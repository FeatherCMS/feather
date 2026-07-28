import AdminOpenAPI

struct AdminRemoveContactFormFieldOpenAPIRepository {
    let api: AdminAPI
    func get(formId: String, id: String) async throws
        -> AdminContactFormFieldRow
    {
        try await AdminListContactFormFieldsOpenAPIRepository(api: api)
            .list(formId: formId).first { $0.id == id }
            ?? {
                throw OpenAPIRepositoryError.notFound(
                    message: "This form field could not be found."
                )
            }()
    }
    func remove(formId: String, id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            if formId.isEmpty {
                switch try await client.contactFieldDelete(
                    path: .init(contactFormItemId: id)
                ) {
                case .noContent: return
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound(
                        message: "This form field could not be found."
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized(
                        message: "Please sign in again to delete form fields."
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: "Your account cannot delete form fields."
                    )
                }
            }
            let response = try await client.contactFormItemDelete(
                path: .init(contactFormId: formId, contactFormItemId: id)
            )
            switch response {
            case .noContent: return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This form field could not be found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete form fields."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete form fields."
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
