import FeatherDatabaseTesting
import FeatherHTTP
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RoleDeleteTests {
    private enum QueryKey: DatabaseQueryKey {
        case delete
    }

    @Test
    func deletesSelectedRoles() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .delete)]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .delete,
            path: "/api/v1/admin/user/roles",
            body: Components.Schemas.DeleteRequestSchema(ids: ["role-1"])
        )

        _ = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 204,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
