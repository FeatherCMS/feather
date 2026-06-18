import AdminOpenAPI
import Hummingbird

struct AdminListSystemVariableOpenAPIRepository:
    AdminListSystemVariableRepository
{
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view system variables."
    private let listForbiddenMessage =
        "Your account cannot access system variables."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this system variable."
    private let deleteForbiddenMessage =
        "Your account cannot delete this system variable."
    private let deleteNotFoundMessage =
        "This system variable could not be found."

    init(api: AdminAPI) {
        self.api = api
    }

    func listSystemVariables(
        page: Int,
        search: String?
    ) async throws -> AdminListSystemVariableModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .systemVariableSearch(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 20, number: page),
                            filters: .init(search: search)
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
            let response =
                try await client
                .systemVariableDelete(path: .init(systemVariableId: id))

            switch response {
            case .noContent:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: deleteForbiddenMessage
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: deleteNotFoundMessage
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
