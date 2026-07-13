import AdminOpenAPI

struct AdminManageContactFormSubmissionsOpenAPIRepository {
    let api: AdminAPI

    func list(formId: String) async throws -> [AdminManageContactFormSubmissionRow] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionList(path: .init(contactFormId: formId))
            switch response {
            case .ok(let value): return try value.body.json.map(map)
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view submissions.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view submissions.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func get(formId: String, id: String) async throws -> AdminManageContactFormSubmissionRow {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionGet(path: .init(contactFormId: formId, contactFormSubmissionId: id))
            switch response {
            case .ok(let value): return try map(value.body.json)
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This submission could not be found.")
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view this submission.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view this submission.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func update(formId: String, id: String, status: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormSubmissionUpdate(path: .init(contactFormId: formId, contactFormSubmissionId: id), body: .json(.init(status: status)))
            switch response {
            case .ok: return
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This submission could not be found.")
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to update submissions.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot update submissions.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    private func map(_ item: Components.Schemas.ContactFormSubmissionSchema) -> AdminManageContactFormSubmissionRow {
        .init(id: item.id, formId: item.formId, status: item.status, submittedAt: String(item.submittedAt), values: item.values.additionalProperties)
    }
}
