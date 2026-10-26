import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import NewsAdminAPI
import NewsApplication
import NewsModule
import OpenAPIRuntime
import WebModule
import WebModuleWebAdmin

extension NewsModule.Category.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> NewsModule.Category.Detail.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryGet(
                    .init(path: .init(newsCategoryId: id))
                )
                switch response {
                case .ok(let value):
                    let schema = try value.body.json
                    return .init(
                        id: schema.id,
                        title: schema.title,
                        excerpt: schema.excerpt,
                        content: schema.content,
                        imageAssetId: schema.imageAssetId,
                        metadata: News.Metadata.Form.Input(
                            metadataSlug: schema.metadata.slug,
                            status: schema.metadata.status,
                            publicationTimestamp: schema.metadata
                                .publicationDate,
                            expirationTimestamp: schema.metadata.expirationDate,
                            title: schema.metadata.title,
                            excerpt: schema.metadata.excerpt,
                            imageURL: schema.metadata.imageURL,
                            canonicalURL: schema.metadata.canonicalURL,
                            noIndex: schema.metadata.noIndex,
                            primaryKeyword: schema.metadata.primaryKeyword,
                            cssCodeInjection: schema.metadata.cssCodeInjection,
                            javascriptCodeInjection: schema.metadata
                                .javascriptCodeInjection,
                            structuredDataCodeInjection: schema.metadata
                                .structuredDataCodeInjection
                        )
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }

        func update(
            id: String,
            input: NewsModule.Category.Form.Input
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsCategoryPut(
                    .init(
                        path: .init(newsCategoryId: id),
                        body: .json(
                            .init(
                                title: input.title.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                excerpt: input.excerpt.trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ),
                                content: input.content,
                                imageAssetId: input.imageAssetId.isEmpty
                                    ? nil
                                    : input.imageAssetId,
                                metadata: .init(
                                    slug: input.metadata.slug
                                        .trimmingCharacters(
                                            in: .whitespacesAndNewlines
                                        ),
                                    status: input.metadata.status,
                                    publicationDate: WebModule.Metadata
                                        .SchemaBuilder
                                        .parseTimestamp(
                                            input.metadata.publicationDate
                                        ),
                                    expirationDate: WebModule.Metadata
                                        .SchemaBuilder
                                        .parseTimestamp(
                                            input.metadata.expirationDate
                                        ),
                                    title: input.metadata.metaTitle.emptyToNil,
                                    excerpt: input.metadata.metaExcerpt
                                        .emptyToNil,
                                    imageURL: input.metadata.imageURL
                                        .emptyToNil,
                                    canonicalURL: input.metadata.canonicalURL
                                        .emptyToNil,
                                    noIndex: input.metadata.noIndex ?? false,
                                    primaryKeyword: input.metadata
                                        .primaryKeyword.emptyToNil,
                                    cssCodeInjection: input.metadata
                                        .cssCodeInjection.emptyToNil,
                                    javascriptCodeInjection: input.metadata
                                        .javascriptCodeInjection.emptyToNil,
                                    structuredDataCodeInjection: input.metadata
                                        .structuredDataCodeInjection.emptyToNil
                                )
                            )
                        )
                    )
                )
                switch response {
                case .ok:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }
    }
}
