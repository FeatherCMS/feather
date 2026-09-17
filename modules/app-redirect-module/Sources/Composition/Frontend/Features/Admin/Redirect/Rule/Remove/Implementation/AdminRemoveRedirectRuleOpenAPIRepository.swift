import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import RedirectAdminAPI
import RedirectContracts

struct AdminRemoveRedirectRuleOpenAPIRepository:
    AdminRemoveRedirectRuleRepository
{
    let api: RedirectAdminAPIClient

    func names(ids: [String]) async throws -> [String] {
        try await withDetails(ids: ids)
    }

    func delete(ids: [String]) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleRemove(
                body: .json(.init(ids: ids, results: false, summary: true))
            )
            switch response {
            case .ok: return
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

    private func withDetails(ids: [String]) async throws -> [String] {
        try await withThrowingTaskGroup(of: String.self) { group in
            for id in ids { group.addTask { try await detail(id: id) } }
            var result: [String] = []
            for try await detail in group { result.append(detail) }
            return result
        }
    }

    private func detail(id: String) async throws -> String {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.redirectRuleGet(
                path: .init(redirectRuleId: id),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let okResponse):
                let rule = try okResponse.body.json
                return rule.source
            case .notFound: throw OpenAPIRepositoryError.notFound
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
