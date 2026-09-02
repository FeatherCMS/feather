import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebMetadataOpenAPIRepository:
    AdminListWebMetadataRepository
{
    let api: WebAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view web metadata."
    private let listForbiddenMessage =
        "Your account cannot access web metadata."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this web metadata."
    private let deleteForbiddenMessage =
        "Your account cannot delete this web metadata."
    private let deleteNotFoundMessage =
        "This web metadata could not be found."

    init(api: WebAdminAPIClient) {
        self.api = api
    }

    func listMetadataEntries(
        page: Int,
        search: String?,
        referenceType: String?
    ) async throws -> AdminListWebMetadataModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webMetadataSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(
                                search: search,
                                referenceType: referenceType
                            )
                        )
                    )
                )

            switch response {
            case .ok(let okResponse):
                let body = try okResponse.body.json
                return .init(
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    pageSize: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: listUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: listForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.webMetadataDelete(
                body: .json(.init(ids: [id], results: false, summary: true))
            )
        }
    }

}
