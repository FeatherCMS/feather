import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct PermissionListTests {
    private enum QueryKey: DatabaseQueryKey {
        case permissionList
    }

    private func array(from body: String) throws -> [[String: Any]] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
    }

    private func permissionRow() -> MockDatabaseRow {
        .init([
            "id": .string("permission-1"),
            "key": .string("system.admin.access"),
            "name": .string("Admin access"),
            "notes": .null,
        ])
    }

    @Test
    func returnsFilteredDatabaseResults() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .permissionList,
                    rows: [permissionRow()]
                )
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path:
                "/api/v1/admin/system/permissions?search=admin&ids=permission-1&ids=permission-2&limit=7"
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try array(from: body)
        #expect(items.count == 1)
        #expect(items.first?["id"] as? String == "permission-1")
        #expect(items.first?["key"] as? String == "system.admin.access")
        try await connection.assertAllResponsesConsumed()
    }
}
