import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RoleCreateTests {
    private enum QueryKey: DatabaseQueryKey {
        case insert
        case find
    }

    @Test
    func createsRole() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(key: .insert),
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("created-1"),
                            "key": .string("user.editor"),
                            "name": .string("Editor"),
                            "notes": .string("Can edit content."),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                ),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/user/roles",
            body: Components.Schemas.UserRoleCreateSchema(
                key: "user.editor",
                name: "Editor",
                notes: "Can edit content."
            )
        )

        let body = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 201,
            using: executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        #expect(json["id"] as? String == "created-1")
        #expect(json["key"] as? String == "user.editor")
        #expect(json["name"] as? String == "Editor")
        #expect(json["notes"] as? String == "Can edit content.")
        try await connection.assertAllResponsesConsumed()
    }
}
