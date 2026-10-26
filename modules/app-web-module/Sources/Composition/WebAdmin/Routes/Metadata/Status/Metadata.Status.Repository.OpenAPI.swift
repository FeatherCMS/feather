import FeatherWebAdmin
import FeatherWebShared
import Foundation
import OpenAPIRuntime
import WebAdminAPI
public import WebModule

extension WebModule.Metadata.Status.Repository {
    public struct OpenAPI: Interface, Sendable {
        private let api: API.Client

        public init(api: API.Client) {
            self.api = api
        }

        public func update(
            referenceType: String,
            referenceID: String,
            status: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let searchResponse = try await client.metadataQuery(
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
                let metadataID: String
                switch searchResponse {
                case .ok(let response):
                    let body = try response.body.json
                    guard
                        let entry = body.data.items.first(where: {
                            $0.referenceId == referenceID
                        })
                    else {
                        throw OpenAPIRepositoryError.notFound
                    }
                    metadataID = entry.id
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

                let patchResponse = try await client.metadataPatch(
                    path: .init(metadataId: metadataID),
                    query: .init(updateMask: "status"),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(status: status))
                )
                switch patchResponse {
                case .ok:
                    return
                case .badRequest(let response):
                    let data = try JSONEncoder()
                        .encode(
                            try response.body.json
                        )
                    throw OpenAPIRepositoryError.parsedFailure(
                        statusCode: 400,
                        responseBody: String(data: data, encoding: .utf8)
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
}
