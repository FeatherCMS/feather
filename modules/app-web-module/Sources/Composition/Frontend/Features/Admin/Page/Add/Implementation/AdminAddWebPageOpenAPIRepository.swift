import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminAddWebPageOpenAPIRepository: AdminAddWebPageRepository {
    let api: WebAdminAPIClient

    func create(
        input: WebPageFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webPageCreate(
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
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to create this web page."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot create web pages."
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
