import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct PermissionDeleteTests {
    private enum QueryKey: DatabaseQueryKey {
        case permissionDelete
    }

    @Test
    func deletesSelectedPermissions() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [.init(key: .permissionDelete)]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .delete,
            path: "/api/v1/admin/system/permissions",
            body: Components.Schemas.DeleteRequestSchema(ids: ["permission-1"])
        )

        _ = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 204,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
