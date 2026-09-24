import FeatherAdmin
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import WebAdminAPI

struct AdminViewWebPageOpenAPIRepository: AdminViewWebPageRepository {
    let api: WebAdminAPIClient
    let mediaAPI: MediaAdminAPIClient

    func get(
        id: String
    ) async throws -> WebPageDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webPageGet(
                    path: .init(webPageId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let page = try okResponse.body.json
                return .init(
                    id: page.id,
                    title: page.title,
                    excerpt: page.excerpt,
                    content: page.content,
                    imageAsset: try await mediaAPI.loadImageAsset(
                        assetId: page.imageAssetId
                    )
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
