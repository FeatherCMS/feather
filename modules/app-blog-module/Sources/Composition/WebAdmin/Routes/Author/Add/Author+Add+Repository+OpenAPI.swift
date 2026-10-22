import BlogAdminAPI
import BlogModule
import FeatherWebShared
import OpenAPIRuntime

extension Author.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(input: Author.Form.Input) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogAuthorPost(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            name: input.normalizedName,
                            excerpt: input.normalizedExcerpt,
                            content: input.normalizedContent,
                            profileImageAssetId: input
                                .normalizedProfileImageAssetId
                        )
                    )
                )
                switch response {
                case .created:
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
