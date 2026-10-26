import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityCreateTests {
    private enum QueryKey: DatabaseQueryKey {
        case insert
        case find
        case clearRoles
        case roleIDs
    }

    @Test
    func createsIdentity() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .insert,
                ),
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("created-1"),
                            "name": .string("Ada Lovelace"),
                            "status": .string("active"),
                            "is_root": .bool(false),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                ),
                .init(key: .clearRoles),
                .init(key: .roleIDs),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/user/identities",
            body: Components.Schemas.UserIdentityCreateSchema(
                name: "Ada Lovelace",
                status: .active,
                roleIds: []
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
        #expect(json["name"] as? String == "Ada Lovelace")
        #expect(json["status"] as? String == "active")
        try await connection.assertAllResponsesConsumed()
    }
}
