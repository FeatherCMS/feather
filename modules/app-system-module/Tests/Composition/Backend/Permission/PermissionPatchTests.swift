import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct PermissionPatchTests {
    private enum QueryKey: DatabaseQueryKey {
        case permissionFind
        case permissionUpdate
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
            "key": .string("system.admin.access"),
            "name": .string("Admin access"),
            "notes": .null,
        ])
    }

    @Test
    func appliesUpdateMask() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .permissionFind,
                    rows: [permissionRow()]
                ),
                .init(key: .permissionUpdate),
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .patch,
            path:
                "/api/v1/admin/system/permissions/permission-1?updateMask=key",
            body: Components.Schemas.SystemPermissionPatchSchema(
                key: "system.admin.updated"
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["key"] as? String == "system.admin.updated")
        #expect(json["name"] as? String == "Admin access")
        try await connection.assertAllResponsesConsumed()
    }
}
