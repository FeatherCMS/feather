import AdminOpenAPI

struct AdminAddContactFieldOpenAPIRepository {
    let api: AdminAPI
    func createField(form: ContactFieldFormInput) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let body:
                Components.RequestBodies.ContactFormItemCreateRequestBody =
                    .json(
                        .init(
                            key: form.key,
                            _type: form.type,
                            label: form.label,
                            allowedValues: form.normalizedAllowedValues,
                            isRequired: form.isRequiredValue
                        )
                    )
            let response = try await client.contactFieldCreate(body: body)
            switch response {
            case .created: return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create a form field."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create form fields."
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
