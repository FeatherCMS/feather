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
            try await withThrowingTaskGroup(of: (Int, String).self) { group in
                for (index, id) in ids.enumerated() {
                    group.addTask {
                        let response = try await client.systemVariableGet(
                            path: .init(systemVariableId: id),
                            headers: .init(accept: [.init(contentType: .json)])
                        )
                        guard case .ok(let result) = response else {
                            return (index, "Variable not found (ID: \(id))")
                        }
                        return (index, (try? result.body.json.name)
                            ?? "Variable not found (ID: \(id))")
                    }
                }
                var result: [(Int, String)] = []
                for try await item in group { result.append(item) }
                return result.sorted { $0.0 < $1.0 }.map(\.1)
            }
        }
    }
}
