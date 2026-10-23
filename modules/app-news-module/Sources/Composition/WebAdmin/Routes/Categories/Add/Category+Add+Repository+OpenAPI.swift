import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import NewsAdminAPI
import OpenAPIRuntime
import NewsModule

extension Category.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(
            input: Components.Schemas.NewsCategoryCreateSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryCreate(
                    .init(body: .json(input))
                )
                switch response {
                case .created:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }
    }
}
