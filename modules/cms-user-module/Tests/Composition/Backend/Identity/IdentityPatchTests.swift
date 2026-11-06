import FeatherDatabaseTesting
import FeatherHTTP
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityPatchTests {

    private enum QueryKey: DatabaseQueryKey {}

    @Test
    func rejectsSelectedFieldMissingFromBody() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path: "/api/v1/admin/user/identities/identity-1?updateMask=name",
            body: Components.Schemas.UserIdentityPatchSchema()
        )

        _ = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func rejectsUnknownUpdateMaskField() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path:
                "/api/v1/admin/user/identities/identity-1?updateMask=unknown",
            body: Components.Schemas.UserIdentityPatchSchema()
        )

        _ = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
