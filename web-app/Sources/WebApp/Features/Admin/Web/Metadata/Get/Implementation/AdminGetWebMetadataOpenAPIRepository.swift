import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminGetWebMetadataOpenAPIRepository: AdminGetWebMetadataRepository {
    let api: AdminAPI

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
                return .init(
                    id: entry.id,
                    referenceType: entry.referenceType ?? "",
                    referenceId: entry.referenceId ?? "",
                    slug: entry.slug,
                    publicationDate: formatDate(entry.publicationDate),
                    expirationDate: formatDate(entry.expirationDate),
                    status: entry.status.capitalized,
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
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Web metadata not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to load this metadata entry."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot access metadata entries."
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
