import AdminOpenAPI

struct AdminNewsletterCampaignAPIClient {
    let api: AdminAPI

    func list() async throws -> [AdminNewsletterCampaignItem] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterList()
            switch response {
            case .ok(let value):
                return try value.body.json.map {
                    .init(id: $0.id, name: $0.name, fromEmail: $0.fromEmail)
                }
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view newsletters."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view newsletters."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func get(id: String) async throws -> AdminNewsletterCampaignItem {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterGet(
                path: .init(contactNewsletterId: id)
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                return .init(
                    id: item.id,
                    name: item.name,
                    fromEmail: item.fromEmail
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view this newsletter."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot view this newsletter."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This newsletter could not be found."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func update(id: String, name: String, fromEmail: String) async throws
        -> AdminNewsletterCampaignItem
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterUpdate(
                path: .init(contactNewsletterId: id),
                body: .json(.init(name: name, fromEmail: fromEmail))
            )
            switch response {
            case .ok(let value):
                let item = try value.body.json
                return .init(
                    id: item.id,
                    name: item.name,
                    fromEmail: item.fromEmail
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit newsletters."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit newsletters."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This newsletter could not be found."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func remove(id: String) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.contactNewsletterDelete(
                path: .init(contactNewsletterId: id)
            )
            switch response {
            case .noContent: return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to delete newsletters."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete newsletters."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This newsletter could not be found."
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
        for id in ids {
            try await remove(id: id)
        }
    }
}
