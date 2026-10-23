import NewsApplication
import FeatherWebAdmin
import FeatherWebShared
import NewsAdminAPI
import NewsModule
import OpenAPIRuntime

extension Category.Detail.Repository {
    struct OpenAPI: Category.Detail.Repository.Interface,
        Category.Edit.Repository.Interface,
        Category.Remove.Repository.Interface
    {
        let api: API.Client

        func get(
            id: String
        ) async throws
            -> Components.Schemas.NewsCategoryDetailSchema
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryGet(
                    .init(path: .init(newsCategoryId: id))
                )
                switch response {
                case .ok(let value):
                    return try value.body.json
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }

        func update(
            id: String,
            input: Components.Schemas.NewsCategoryCreateSchema
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryUpdate(
                    .init(path: .init(newsCategoryId: id), body: .json(input))
                )
                switch response {
                case .ok:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }

        func remove(
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryRemove(
                    .init(
                        body: .json(
                            .init(ids: [id])
                        )
                    )
                )
                switch response {
                case .noContent:
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
