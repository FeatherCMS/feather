import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebDomain
import WebModule

extension Page.Metadata.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(id: String) async throws -> AdminMetadataFormValue {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.pageGet(
                    path: .init(pageId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let page = try okResponse.body.json
                    return WebModule.Metadata.SchemaBuilder.formValue(
                        from: page.metadata,
                        fallbackTitle: page.title,
                        fallbackExcerpt: page.excerpt
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
