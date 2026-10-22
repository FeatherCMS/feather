import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Settings.Edit.Repository {

    struct OpenAPI:
        Settings.Edit.Repository.Interface
    {
        let api: API.Client
        let targetUserID: String?

        func loadSettings() async throws -> Settings.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                if let targetUserID {
                    let response = try await client.accountUserSettingsGet(
                        .init(
                            path: .init(userId: targetUserID),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
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
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }
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
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        func saveSettings(
            input: Settings.Edit.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let body:
                    AccountAdminAPI.Components.RequestBodies
                        .AccountSettingsUpdateRequestBody = .json(
                            .init(
                                language: input.language,
                                timezone: input.timezone,
                                pageSize: input.pageSize
                            )
                        )
                if let targetUserID {
                    let response = try await client.accountUserSettingsUpdate(
                        .init(
                            path: .init(userId: targetUserID),
                            headers: .init(accept: [.init(contentType: .json)]),
                            body: body
                        )
                    )
                    switch response {
                    case .ok:
                        return
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }
                let response = try await client.accountSettingsUpdate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: body
                )
                switch response {
                case .ok:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

    }
}
