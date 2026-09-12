import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminListSystemVariableOpenAPIRepository:
    AdminListSystemVariableRepository
{
    let api: SystemAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view system variables."
    private let listForbiddenMessage =
        "Your account cannot access system variables."
    init(api: SystemAdminAPIClient) {
        self.api = api
    }

    func listSystemVariables(
        page: Int,
        search: String?,
        ids: [String]? = nil
    ) async throws
        -> SystemAdminAPI.Components.Responses
        .SystemVariableListItemSearchSchemaSearchResponse
    {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemVariableSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(
                                size: max(
                                    AdminListSystemVariable.pageSize,
                                    ids?.count ?? 0
                                ),
                                number: page
                            ),
                            filters: .init(search: search, ids: ids)
                        )
                    )
                )

            switch response {
            case .ok(let okResponse):
                return okResponse
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

}
