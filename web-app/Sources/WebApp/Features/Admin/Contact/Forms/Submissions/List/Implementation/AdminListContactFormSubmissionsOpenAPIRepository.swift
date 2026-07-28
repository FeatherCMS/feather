import AdminOpenAPI

struct AdminListContactFormSubmissionsOpenAPIRepository {
    let api: AdminAPI
    func list(formId: String) async throws -> [AdminContactFormSubmissionItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionList(
                path: .init(contactFormId: formId)
            )
            switch response {
            case .ok(let value): return try value.body.json.map(map)
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view submissions."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view submissions."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
    private func map(_ item: Components.Schemas.ContactFormSubmissionSchema)
        -> AdminContactFormSubmissionItem
    {
        let values = item.values.additionalProperties
        return .init(
            id: item.id,
            formId: item.formId,
            status: item.status,
            createdAt: DateFormatting.formatUnixTimestamp(item.createdAt),
            email: values.first { $0.key.lowercased() == "email" }?.value,
            values: values
        )
    }
}
