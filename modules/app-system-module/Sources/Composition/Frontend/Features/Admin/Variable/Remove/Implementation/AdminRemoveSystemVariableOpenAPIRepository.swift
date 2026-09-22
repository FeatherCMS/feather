import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI

struct AdminRemoveSystemVariableOpenAPIRepository:
    AdminRemoveSystemVariableRepository
{
    let api: SystemAdminAPIClient

    func delete(
        ids: [String]
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableRemove(
                body: .json(.init(ids: ids, results: false, summary: true))
            )
            switch response {
            case .ok:
                return
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

    func names(ids: [String]) async throws -> [String] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.systemVariableSearch(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        page: .init(size: max(ids.count, 1), number: 1),
                        filters: .init(ids: ids)
                    )
                )
            )
            switch response {
            case .ok(let result):
                let byID = Dictionary(
                    uniqueKeysWithValues: try result.body.json.data.items.map {
                        ($0.id, $0)
                    }
                )
                return ids.map { id in
                    byID[id]?.name ?? byID[id]?.key
                        ?? "Variable not found (id: \(id))"
                }
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
