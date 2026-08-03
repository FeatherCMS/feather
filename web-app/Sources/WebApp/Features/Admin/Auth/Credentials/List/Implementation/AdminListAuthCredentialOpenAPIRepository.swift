import AdminOpenAPI
import Hummingbird

struct AdminListAuthCredentialOpenAPIRepository: AdminListAuthCredentialRepository {
    let api: AdminAPI

    func list(
        accountID: String,
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserCredentialListItemSchema],
        total: Int,
        page: Int,
        size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userCredentialSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: size, number: page),
                        filters: .init(search: search, accountID: accountID)
                    )
                )
            )
            switch response {
            case .ok(let ok):
                let body = try ok.body.json
                return (
                    items: body.data.items,
                    total: body.data.total,
                    page: body.query.page.number,
                    size: body.query.page.size
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view credentials."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access credentials."
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
