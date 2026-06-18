import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditWebMetadataOpenAPIRepository: AdminEditWebMetadataRepository {
    let api: AdminAPI

    func load(
        id: String
    ) async throws -> WebMetadataDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMetadataGet(
                path: .init(webMetadataId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let entry = try okResponse.body.json
                return map(entry)
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

    func update(
        id: String,
        input: WebMetadataFormInput
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMetadataUpdate(
                path: .init(webMetadataId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        slug: input.normalizedSlug,
                        publicationDate: parseDate(
                            input.normalizedPublicationDate
                        ),
                        expirationDate: parseDate(
                            input.normalizedExpirationDate
                        ),
                        status: input.normalizedStatus,
                        title: emptyToNil(input.normalizedTitle),
                        excerpt: emptyToNil(input.normalizedExcerpt),
                        imageUrl: emptyToNil(input.normalizedImageUrl),
                        canonicalUrl: emptyToNil(input.normalizedCanonicalUrl),
                        noIndex: input.noIndex.value,
                        primaryKeyword: emptyToNil(
                            input.normalizedPrimaryKeyword
                        ),
                        cssCodeInjection: emptyToNil(
                            input.normalizedCSSCodeInjection
                        ),
                        javascriptCodeInjection: emptyToNil(
                            input.normalizedJavaScriptCodeInjection
                        ),
                        structuredDataCodeInjection: emptyToNil(
                            input.normalizedStructuredDataCodeInjection
                        )
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Web metadata not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this metadata entry."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit metadata entries."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func parseDate(
        _ value: String
    ) -> Double? {
        guard !value.isEmpty else {
            return nil
        }
        if let date = makeDateTimeFormatter().date(from: value) {
            return date.timeIntervalSince1970
        }
        if let date = makeDateOnlyFormatter().date(from: value) {
            return date.timeIntervalSince1970
        }
        return ISO8601DateFormatter().date(from: value)?.timeIntervalSince1970
    }

    private func formatDate(
        _ timestamp: Double?
    ) -> String {
        guard let timestamp else {
            return ""
        }
        return makeDateTimeFormatter()
            .string(
                from: Date(timeIntervalSince1970: timestamp)
            )
    }

    private func emptyToNil(
        _ value: String
    ) -> String? {
        value.isEmpty ? nil : value
    }

    private func map(
        _ entry: Components.Schemas.WebMetadataDetailSchema
    ) -> WebMetadataDetailsModel {
        .init(
            id: entry.id,
            referenceType: entry.referenceType ?? "",
            referenceId: entry.referenceId ?? "",
            slug: entry.slug,
            publicationDate: formatDate(entry.publicationDate),
            expirationDate: formatDate(entry.expirationDate),
            status: entry.status,
            title: entry.title ?? "",
            excerpt: entry.excerpt ?? "",
            imageUrl: entry.imageUrl ?? "",
            canonicalUrl: entry.canonicalUrl ?? "",
            noIndex: entry.noIndex,
            primaryKeyword: entry.primaryKeyword,
            cssCodeInjection: entry.cssCodeInjection ?? "",
            javascriptCodeInjection: entry.javascriptCodeInjection ?? "",
            structuredDataCodeInjection: entry.structuredDataCodeInjection
                ?? "",
            createdAt: formatDate(entry.createdAt),
            updatedAt: formatDate(entry.updatedAt)
        )
    }

    private func makeDateOnlyFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private func makeDateTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }
}
