import AdminOpenAPI

struct AdminListSystemJobOpenAPIRepository: AdminListSystemJobRepository {
    let api: AdminAPI

    func list() async throws -> [Components.Schemas.SystemJobSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemJobList(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                return try value.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view worker jobs."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access worker jobs."
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
