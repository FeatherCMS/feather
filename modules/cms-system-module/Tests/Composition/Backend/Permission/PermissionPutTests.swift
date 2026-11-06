import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct PermissionPutTests {
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
            "key": .string("system:admin:access"),
            "name": .string("Admin access"),
            "notes": .null,
        ])
    }

    @Test
    func replacesPermissionFields() async throws {
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
            method: .put,
            path: "/api/v1/admin/system/permissions/permission-1",
            body: Components.Schemas.SystemPermissionCreateSchema(
                key: "system.admin.replaced",
                name: "Replaced name",
                notes: "Replaced notes"
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["key"] as? String == "system.admin.replaced")
        #expect(json["name"] as? String == "Replaced name")
        #expect(json["notes"] as? String == "Replaced notes")
        try await connection.assertAllResponsesConsumed()
    }
}
