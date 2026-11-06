import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(input: Tag.Form.Input) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogTagPost(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            title: input.normalizedTitle,
                            excerpt: input.normalizedExcerpt,
                            content: input.normalizedContent,
                            imageAssetId: input.normalizedImageAssetId
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
