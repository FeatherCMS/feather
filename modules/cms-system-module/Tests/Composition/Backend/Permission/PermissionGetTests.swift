import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct PermissionGetTests {
    private enum QueryKey: DatabaseQueryKey {
        case permissionFind
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    private func permissionRow() -> MockDatabaseRow {
        .init([
            "id": .string("permission-1"),
            "key": .string("system:admin:access"),
            "name": .string("Admin access"),
            "notes": .null,
        ])
    }

    @Test
    func returnsPermissionByID() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .permissionFind,
                    rows: [permissionRow()]
                )
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/system/permissions/permission-1"
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "permission-1")
        #expect(json["key"] as? String == "system:admin:access")
        try await connection.assertAllResponsesConsumed()
    }
}
