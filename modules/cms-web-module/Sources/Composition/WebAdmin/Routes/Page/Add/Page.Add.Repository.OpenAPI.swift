import FeatherDomain
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Page.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(
            input: Page.Form.Input,
            mediaDraftID: String
        ) async throws -> String {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.pageCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            title: input.normalizedTitle,
                            excerpt: input.normalizedExcerpt,
                            content: input.normalizedContent,
                            imageAssetId: input.normalizedImageAssetId,
                        )
                    )
                )

                switch response {
                case .created(let created):
                    let detail = try created.body.json
                    do {
                        try await api.mediaAdminAPI().moveFolder(
                            fromPath: "web/pages/drafts/\(mediaDraftID)",
                            toPath: "web/pages/\(detail.metadata.slug)"
                        )
                    }
                    catch OpenAPIRepositoryError.notFound {
                        return detail.id
                    }
                    return detail.id
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
