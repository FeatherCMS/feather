import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RolePatchTests {

    private enum QueryKey: DatabaseQueryKey {
        case find
        case update
        case updated
    }

    @Test
    func clearsSelectedNullableFieldWhenOmittedFromBody() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("role-1"),
                            "key": .string("user.editor"),
                            "name": .string("Editor"),
                            "notes": .string("Can edit content."),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                ),
                .init(key: .update),
                .init(
                    key: .updated,
                    rows: [
                        .init([
                            "id": .string("role-1"),
                            "key": .string("user.editor"),
                            "name": .string("Editor"),
                            "notes": .null,
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
            method: .patch,
            path: "/api/v1/admin/user/roles/role-1?updateMask=notes",
            body: Components.Schemas.UserRolePatchSchema()
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
        #expect(json["notes"] == nil || json["notes"] is NSNull)
        try await connection.assertAllResponsesConsumed()
    }
}
