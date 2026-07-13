import AdminOpenAPI

struct AdminAddContactFormItemOpenAPIRepository {
    let api: AdminAPI
    func createItem(formId: String, form: ContactFormItemAddForm) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemCreate(path: .init(contactFormId: formId), body: .json(.init(key: form.key, _type: form.type, label: form.label, allowedValues: form.normalizedAllowedValues, isRequired: form.isRequiredValue, position: form.normalizedPosition)))
            switch response {
            case .created: return
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to create a form item.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot create form items.")
            case let .undocumented(statusCode, response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
