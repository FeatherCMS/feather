import FeatherDomain
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
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
                            publicationDate:
                                api.adminDateFormatter.unixTimestamp(
                                    fromInput:
                                        input.normalizedPublicationDate
                                ),
                            expirationDate:
                                api.adminDateFormatter.unixTimestamp(
                                    fromInput:
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

        private func map(
            _ entry: Components.Schemas.MetadataDetailSchema
        ) -> WebModule.Metadata.Edit.Model {
            .init(
                id: entry.id,
                referenceType: entry.referenceType ?? "",
                referenceId: entry.referenceId ?? "",
                slug: entry.slug,
                publicationDate: entry.publicationDate.map {
                    api.adminDateFormatter.formatDateTimeInput(
                        unixTimestamp: $0
                    )
                } ?? "",
                expirationDate: entry.expirationDate.map {
                    api.adminDateFormatter.formatDateTimeInput(
                        unixTimestamp: $0
                    )
                } ?? "",
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
                createdAt: api.adminDateFormatter.formatDateTime(
                    unixTimestamp: entry.createdAt
                ),
                updatedAt: api.adminDateFormatter.formatDateTime(
                    unixTimestamp: entry.updatedAt
                )
            )
        }

    }
}
