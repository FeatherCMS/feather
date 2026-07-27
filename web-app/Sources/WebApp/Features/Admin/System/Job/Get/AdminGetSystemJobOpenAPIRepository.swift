import AdminOpenAPI

struct AdminGetSystemJobOpenAPIRepository: AdminGetSystemJobRepository {
    let api: AdminAPI

    func get(id: String) async throws -> Components.Schemas.SystemJobSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemJobGet(
                path: .init(systemJobId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                return try value.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Worker job not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view this worker job."
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
