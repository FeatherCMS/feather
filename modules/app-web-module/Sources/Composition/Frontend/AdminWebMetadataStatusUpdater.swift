import FeatherAdmin
import OpenAPIRuntime
import WebAdminAPI

public struct AdminWebMetadataStatusUpdater: Sendable {
    private let api: WebAdminAPIClient

    public init(api: WebAdminAPIClient) {
        self.api = api
    }

    public func update(
        referenceType: String,
        referenceID: String,
        status: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let searchResponse = try await client.webMetadataSearch(
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
                    throw OpenAPIRepositoryError.notFound(
                        message: "Web metadata not found."
                    )
                }
                metadataID = entry.id
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this metadata."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit metadata entries."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }

            let patchResponse = try await client.webMetadataPatch(
                path: .init(webMetadataId: metadataID),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(.init(status: status))
            )
            switch patchResponse {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "Web metadata not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to update this metadata."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit metadata entries."
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
