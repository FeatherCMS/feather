import AdminOpenAPI

struct AdminEditAccountSettingsOpenAPIRepository:
    AdminEditAccountSettingsRepository
{
    let api: AdminAPI

    func loadSettings() async throws -> AdminEditAccountSettingsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.accountSettingsGet(
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let body = try okResponse.body.json
                return .init(
                    language: body.language,
                    timezone: body.timezone,
                    pageSize: body.pageSize
                )
            case .badRequest(let response):
                throw Self.failure(
                    statusCode: 400,
                    body: try response.body.json
                )
            case .internalServerError(let response):
                throw Self.failure(
                    statusCode: 500,
                    body: try response.body.json
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load account settings."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access account settings."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func saveSettings(
        input: AdminEditAccountSettingsFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.accountSettingsUpdate(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        language: input.language,
                        timezone: input.timezone,
                        pageSize: input.pageSize
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .badRequest(let response):
                throw Self.failure(
                    statusCode: 400,
                    body: try response.body.json
                )
            case .internalServerError(let response):
                throw Self.failure(
                    statusCode: 500,
                    body: try response.body.json
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to save account settings."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot update account settings."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private static func failure(
        statusCode: Int,
        body: Components.Schemas.ServerErrorSchema
    ) -> OpenAPIRepositoryError {
        .failure(
            .init(
                statusCode: statusCode,
                responseBody: nil,
                backendError: .init(
                    code: body.code,
                    message: body.message,
                    reason: body.reason,
                    trace: nil,
                    requestPath: nil,
                    operationID: nil
                )
            )
        )
    }
}
