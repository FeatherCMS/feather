import AdminOpenAPI
import Hummingbird

struct AdminListAuthCredentialAccountOpenAPIRepository:
    AdminListAuthCredentialAccountRepository
{
    let api: AdminAPI

    func list(
        page: Int,
        size: Int,
        search: String?
    ) async throws -> (
        items: [Components.Schemas.UserAccountListItemSchema],
        total: Int,
        page: Int,
        size: Int
    ) {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: size, number: page),
                        filters: .init(search: search)
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
                    message: "Please sign in again to view user accounts."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot access user accounts."
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
