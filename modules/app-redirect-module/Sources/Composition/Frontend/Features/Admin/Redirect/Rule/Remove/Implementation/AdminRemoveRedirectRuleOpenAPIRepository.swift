import FeatherWebAdmin
import OpenAPIRuntime
import RedirectAdminAPI

struct AdminRemoveRedirectRuleOpenAPIRepository:
    AdminRemoveRedirectRuleRepository
{
    let api: RedirectAdminAPIClient


    func delete(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleRemove(
                body: .json(.init(ids: ids))
            )
            switch response {
            case .noContent: return
            case .unauthorized: throw OpenAPIRepositoryError.unauthorized
            case .forbidden: throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

}
