import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension Page.Edit.Template.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            pageID: String
        ) async throws -> Content {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.pageGet(
                    path: .init(pageId: pageID),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let value):
                    let page = try value.body.json
                    return .init(
                        metadataID: page.metadata.id,
                        slug: page.metadata.slug,
                        templateID: page.metadata.template,
                        templateData: page.metadata.templateData
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let body):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: body.body
                    )
                }
            }
        }

        func save(
            metadataID: String,
            templateData: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.metadataPatch(
                    path: .init(metadataId: metadataID),
                    query: .init(updateMask: "templateData"),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(templateData: templateData))
                )
                switch response {
                case .ok:
                    return
                case .badRequest(let body):
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(
                            decoding: try JSONEncoder().encode(
                                try body.body.json
                            ),
                            as: UTF8.self
                        )
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let body):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: body.body
                    )
                }
            }
        }
    }
}
