import AccountAdminAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminEditSettingsOpenAPIRepository:
    AdminEditSettingsRepository
{
    let api: AccountAdminAPIClient

    func loadSettings() async throws -> AdminEditSettingsModel {
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
        input: AdminEditSettingsFormInput
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

}
