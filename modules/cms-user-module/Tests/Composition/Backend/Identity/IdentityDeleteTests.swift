import FeatherDatabaseTesting
import FeatherHTTP
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityDeleteTests {
    private enum QueryKey: DatabaseQueryKey {
        case delete
    }

    @Test
    func deletesSelectedIdentities() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .delete)]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .delete,
            path: "/api/v1/admin/user/identities",
            body: Components.Schemas.DeleteRequestSchema(ids: ["identity-1"])
        )

        _ = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 204,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
