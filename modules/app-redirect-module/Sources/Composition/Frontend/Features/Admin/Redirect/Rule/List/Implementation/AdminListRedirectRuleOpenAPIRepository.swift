import FeatherAdmin
import FeatherContracts
import Foundation
import Hummingbird
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectContracts

struct AdminListRedirectRuleOpenAPIRepository:
    AdminListRedirectRuleRepository
{
    let api: RedirectAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view redirect rules."
    private let listForbiddenMessage =
        "Your account cannot access redirect rules."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this redirect rule."
    private let deleteForbiddenMessage =
        "Your account cannot delete this redirect rule."
    private let deleteNotFoundMessage =
        "This redirect rule could not be found."

    init(api: RedirectAdminAPIClient) {
        self.api = api
    }

    func listRedirectRules(
        page: Int,
        search: String?,
        statusCode: StatusCode?
    ) async throws -> AdminListRedirectRuleModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .redirectRuleSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(
                                search: search,
                                statusCode: statusCode?.rawValue
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
                    pageSize: body.query.page.size,
                    statusCode: body.query.filters.statusCode.map(String.init)
                        ?? ""
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
            _ = try await client.redirectRuleBulkDelete(
                body: .json(.init(ids: [id], summary: true))
            )
        }
    }

}
