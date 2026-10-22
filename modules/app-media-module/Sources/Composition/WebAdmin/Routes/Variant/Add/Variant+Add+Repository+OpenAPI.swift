import FeatherWebAdmin
import FeatherWebShared
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime

extension Variant.Add.Repository {
    struct OpenAPI: Variant.Add.Repository.Interface {
        let api: MediaAdminAPIClient

        func create(
            input: MediaAdminAPI.Components.Schemas.MediaVariantCreateSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaVariantPost(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(input)
                )
                switch response {
                case .created: return
                case .unauthorized: throw OpenAPIRepositoryError.unauthorized
                case .forbidden: throw OpenAPIRepositoryError.forbidden
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
