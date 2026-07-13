import AdminOpenAPI

struct AdminManageContactFormsOpenAPIRepository {
    let api: AdminAPI

    func create(name: String) async throws -> AdminManageContactFormItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormCreate(body: .json(.init(name: name)))
            switch response {
            case .created(let value): let item = try value.body.json; return .init(id: item.id, name: item.name)
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to create contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot create contact forms.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func list() async throws -> [AdminManageContactFormItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormList()
            switch response {
            case .ok(let value): return try value.body.json.map { .init(id: $0.id, name: $0.name) }
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view contact forms.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func get(id: String) async throws -> AdminManageContactFormItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormGet(path: .init(contactFormId: id))
            switch response {
            case .ok(let value): let item = try value.body.json; return .init(id: item.id, name: item.name)
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to view this contact form.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot view this contact form.")
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This contact form could not be found.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func update(id: String, name: String) async throws -> AdminManageContactFormItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormUpdate(path: .init(contactFormId: id), body: .json(.init(name: name)))
            switch response {
            case .ok(let value): let item = try value.body.json; return .init(id: item.id, name: item.name)
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to edit contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot edit contact forms.")
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This contact form could not be found.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }

    func remove(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactFormDelete(path: .init(contactFormId: id))
            switch response {
            case .noContent: return
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized(message: "Please sign in again to delete contact forms.")
            case .forbidden: throw OpenAPIRepositoryError.forbidden(message: "Your account cannot delete contact forms.")
            case .notFound: throw OpenAPIRepositoryError.notFound(message: "This contact form could not be found.")
            case .undocumented(let statusCode, let response): throw try await api.failure(statusCode: statusCode, responseBody: response.body)
            }
        }
    }
}
