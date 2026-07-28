import AdminOpenAPI

struct AdminListContactFormItemsOpenAPIRepository {
    let api: AdminAPI
    func list(formId: String) async throws -> [AdminContactFormItemRow] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemList(
                path: .init(contactFormId: formId)
            )
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(
                        id: $0.id,
                        formId: $0.formId,
                        key: $0.key,
                        type: $0._type,
                        label: $0.label,
                        allowedValues: ($0.allowedValues ?? [])
                            .joined(separator: "\n"),
                        isRequired: $0.isRequired,
                        position: String($0.position)
                    )
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view form fields."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view form fields."
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
