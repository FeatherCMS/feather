import FeatherDomain
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension WebModule.Metadata.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            id: String
        ) async throws -> WebModule.Metadata.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.metadataGet(
                    path: .init(metadataId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let entry = try okResponse.body.json
                    return map(entry)
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

        func load(
            referenceType: String,
            referenceID: String
        ) async throws -> WebModule.Metadata.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.metadataQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: 1),
                            filters: .init(
                                search: referenceID,
                                referenceType: referenceType
                            )
                        )
                    )
                )
                switch response {
                case .ok(let okResponse):
                    let body = try okResponse.body.json
                    guard
                        let entry = body.data.items.first(where: {
                            $0.referenceId == referenceID
                        })
                    else {
                        throw OpenAPIRepositoryError.notFound
                    }
                    return try await load(id: entry.id)
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

        func update(
            id: String,
            input: WebModule.Metadata.Edit.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.metadataUpdate(
                    path: .init(metadataId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            slug: input.normalizedSlug,
                            template: input.normalizedTemplate.emptyToNil,
                            publicationDate: parseDate(
                                input.normalizedPublicationDate
                            ),
                            expirationDate: parseDate(
                                input.normalizedExpirationDate
                            ),
                            status: input.normalizedStatus,
                            title: input.normalizedTitle.emptyToNil,
                            excerpt: input.normalizedExcerpt.emptyToNil,
                            imageUrl: input.normalizedImageUrl,
                            canonicalUrl: input.normalizedCanonicalUrl
                                .emptyToNil,
                            noIndex: input.noIndex.value,
                            primaryKeyword:
                                input.normalizedPrimaryKeyword.emptyToNil,
                            cssCodeInjection:
                                input.normalizedCSSCodeInjection.emptyToNil,
                            javascriptCodeInjection:
                                input.normalizedJavaScriptCodeInjection
                                .emptyToNil,
                            structuredDataCodeInjection:
                                input.normalizedStructuredDataCodeInjection
                                .emptyToNil
                        )
                    )
                )
                switch response {
                case .ok:
                    return
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

        private func parseDate(
            _ value: String
        ) -> Double? {
            guard !value.isEmpty else {
                return nil
            }
            let iso8601 = ISO8601DateFormatter()
            iso8601.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds,
            ]
            if let date = iso8601.date(from: value) {
                return date.timeIntervalSince1970
            }
            iso8601.formatOptions = [.withInternetDateTime]
            if let date = iso8601.date(from: value) {
                return date.timeIntervalSince1970
            }
            if let date = makeDateTimeFormatter().date(from: value) {
                return date.timeIntervalSince1970
            }
            if let date = makeDateOnlyFormatter().date(from: value) {
                return date.timeIntervalSince1970
            }
            return ISO8601DateFormatter().date(from: value)?
                .timeIntervalSince1970
        }

        private func formatDate(
            _ timestamp: Double?
        ) -> String {
            guard let timestamp else {
                return ""
            }
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [
                .withInternetDateTime,
                .withFractionalSeconds,
            ]
            return formatter.string(
                from: Date(timeIntervalSince1970: timestamp)
            )
        }

        private func map(
            _ entry: Components.Schemas.MetadataDetailSchema
        ) -> WebModule.Metadata.Edit.Model {
            .init(
                id: entry.id,
                referenceType: entry.referenceType ?? "",
                referenceId: entry.referenceId ?? "",
                slug: entry.slug,
                publicationDate: formatDate(entry.publicationDate),
                expirationDate: formatDate(entry.expirationDate),
                status: entry.status,
                template: entry.template,
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
}
