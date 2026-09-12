import FeatherAdmin
import Foundation
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
            _ = try await client.systemVariableDelete(
                body: .json(.init(ids: ids, results: false, summary: true))
            )
        }
    }

    func names(ids: [String]) async throws -> [String] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            try await withThrowingTaskGroup(of: String.self) { group in
                for id in ids {
                    group.addTask {
                        let response = try await client.systemVariableGet(
                            path: .init(systemVariableId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        guard case .ok(let result) = response else { return id }
                        return (try? result.body.json.name) ?? id
                    }
                }
                var result: [String] = []
                for try await name in group { result.append(name) }
                return result
            }
        }
    }
}
