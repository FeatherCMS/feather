import FeatherDatabaseTesting
import FeatherHTTP
import HTTPTypes
import Testing
import WebAdminAPI

@Suite
struct PagePatchTests {
    private enum QueryKey: DatabaseQueryKey {
        case unused
    }

    @Test
    func rejectsUnknownUpdateMask() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try APIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path: "/api/v1/admin/web/pages/page-1?updateMask=unknown",
            body: Components.Schemas.PagePatchSchema()
        )

        _ = try await APIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func requiresSelectedNonNullableFieldsInBody() async throws {
        let connection = MockDatabaseConnection<QueryKey>(responses: [])
        let executor = try APIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path: "/api/v1/admin/web/pages/page-1?updateMask=title",
            body: Components.Schemas.PagePatchSchema()
        )

        _ = try await APIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
