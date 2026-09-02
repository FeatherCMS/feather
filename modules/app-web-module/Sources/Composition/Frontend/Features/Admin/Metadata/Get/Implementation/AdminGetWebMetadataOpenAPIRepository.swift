import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminGetWebMetadataOpenAPIRepository: AdminGetWebMetadataRepository {
    let api: WebAdminAPIClient

    func get(
        id: String
    ) async throws -> WebMetadataDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webMetadataGet(
                    path: .init(webMetadataId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let okResponse):
                let entry = try okResponse.body.json
                let model = WebMetadataDetailsModel(
                    id: entry.id,
                    referenceType: entry.referenceType ?? "",
                    referenceId: entry.referenceId ?? "",
                    slug: entry.slug,
                    publicationDate: formatDate(entry.publicationDate),
                    expirationDate: formatDate(entry.expirationDate),
                    status: entry.status.capitalized,
                    template: entry.template,
                    title: entry.title ?? "",
                    excerpt: entry.excerpt ?? "",
                    imageUrl: entry.imageUrl ?? "",
                    canonicalUrl: entry.canonicalUrl ?? "",
                    noIndex: entry.noIndex,
                    primaryKeyword: entry.primaryKeyword,
                    cssCodeInjection: entry.cssCodeInjection ?? "",
                    javascriptCodeInjection: entry.javascriptCodeInjection
                        ?? "",
                    structuredDataCodeInjection: entry
                        .structuredDataCodeInjection ?? "",
                    createdAt: formatDate(entry.createdAt),
                    updatedAt: formatDate(entry.updatedAt)
                )
                return model
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Web metadata not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this web metadata."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot access web metadata."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func formatDate(
        _ timestamp: Double?
    ) -> String {
        guard let timestamp else {
            return ""
        }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
