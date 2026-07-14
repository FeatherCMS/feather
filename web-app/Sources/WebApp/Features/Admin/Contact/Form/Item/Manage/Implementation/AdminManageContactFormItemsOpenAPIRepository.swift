import AdminOpenAPI

struct AdminManageContactFormItemsOpenAPIRepository {
    let api: AdminAPI

    func list(formId: String) async throws -> [AdminManageContactFormItemRow] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemList(path: .init(contactFormId: formId))
            switch response {
            case .ok(let value): return try value.body.json.map { .init(id: $0.id, formId: $0.formId, key: $0.key, type: $0._type, label: $0.label, allowedValues: ($0.allowedValues ?? []).joined(separator: "\n"), isRequired: $0.isRequired, position: String($0.position)) }
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view form fields.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view form fields.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func get(formId: String, id: String) async throws -> AdminManageContactFormItemRow {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemGet(path: .init(contactFormId: formId, contactFormItemId: id))
            switch response {
            case .ok(let value): let item = try value.body.json; return .init(id: item.id, formId: item.formId, key: item.key, type: item._type, label: item.label, allowedValues: (item.allowedValues ?? []).joined(separator: "\n"), isRequired: item.isRequired, position: String(item.position))
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This form field could not be found.")
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view this form field.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view this form field.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func update(formId: String, id: String, form: ContactFormItemAddForm) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemUpdate(path: .init(contactFormId: formId, contactFormItemId: id), body: .json(.init(key: form.key, _type: form.type, label: form.label, allowedValues: form.normalizedAllowedValues, isRequired: form.isRequiredValue)))
            switch response {
            case .ok: return
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This form field could not be found.")
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to edit form fields.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot edit form fields.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func remove(formId: String, id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormItemDelete(path: .init(contactFormId: formId, contactFormItemId: id))
            switch response {
            case .noContent: return
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This form field could not be found.")
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to delete form fields.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot delete form fields.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
