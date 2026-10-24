import FeatherDatabaseTesting
import FeatherHTTP
import HTTPTypes
import Testing
import WebAdminAPI

@Suite
struct MenuItemPatchTests {
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
            path:
                "/api/v1/admin/web/menus/menu-1/items/item-1?updateMask=unknown",
            body: Components.Schemas.MenuItemPatchSchema()
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
            path:
                "/api/v1/admin/web/menus/menu-1/items/item-1?updateMask=label",
            body: Components.Schemas.MenuItemPatchSchema()
        )

        _ = try await APIHTTPTestSupport.send(
            request,
            expectedStatus: 400,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
