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
}
