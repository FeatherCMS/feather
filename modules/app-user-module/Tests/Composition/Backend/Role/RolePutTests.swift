import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RolePutTests {
    private enum QueryKey: DatabaseQueryKey {
        case find
        case update
    }

    @Test
    func replacesRoleFields() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let existing = MockDatabaseRow([
            "id": .string("role-1"),
            "key": .string("user.editor"),
            "name": .string("Editor"),
            "notes": .string("Old notes"),
            "created_at": .date(date),
            "updated_at": .date(date),
        ])
        let updated = MockDatabaseRow([
            "id": .string("role-1"),
            "key": .string("user.editor"),
            "name": .string("Content editor"),
            "notes": .string("Updated notes"),
            "created_at": .date(date),
            "updated_at": .date(date),
        ])
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(key: .find, rows: [existing]),
                .init(key: .update, rows: [updated]),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .put,
            path: "/api/v1/admin/user/roles/role-1",
            body: Components.Schemas.UserRoleUpdateSchema(
                name: "Content editor",
                notes: "Updated notes"
            )
        )

        let body = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        #expect(json["id"] as? String == "role-1")
        #expect(json["key"] as? String == "user.editor")
        #expect(json["name"] as? String == "Content editor")
        #expect(json["notes"] as? String == "Updated notes")
        try await connection.assertAllResponsesConsumed()
    }
}
