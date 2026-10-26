import FeatherWebAdmin
import FeatherWebShared
import NewsAdminAPI
import NewsApplication
import NewsModule
import OpenAPIRuntime

extension Category.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            id: String
        ) async throws -> Category.Detail.Model {
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
    }
}
