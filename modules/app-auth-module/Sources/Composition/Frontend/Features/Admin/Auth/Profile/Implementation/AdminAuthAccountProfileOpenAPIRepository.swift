import AccountAppAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminAuthAccountProfileOpenAPIRepository:
    AdminAuthAccountProfileRepository
{
    let api: AccountAppAPIClient

    func get() async throws -> AdminAuthAccountProfileModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.accountProfileGet(
                .init(headers: .init(accept: [.init(contentType: .json)]))
            )
            switch response {
            case .ok(let value):
                let body = try value.body.json
                return .init(
                    firstName: body.firstName,
                    lastName: body.lastName,
                    imageURL: body.imageURL
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load your profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access this profile."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func update(
        profile: AdminAuthAccountProfileModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.accountProfileUpdate(
                .init(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            firstName: profile.firstName,
                            lastName: profile.lastName,
                            imageURL: profile.imageURL
                        )
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to save your profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit this profile."
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
