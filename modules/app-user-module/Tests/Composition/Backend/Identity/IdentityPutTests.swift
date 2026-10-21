import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityPutTests {
    private enum QueryKey: DatabaseQueryKey {
        case find
        case update
        case updated
        case roleIDs
    }

    @Test
    func replacesIdentityFields() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let existing = MockDatabaseRow([
            "id": .string("identity-1"),
            "name": .string("Ada"),
            "status": .string("invited"),
            "is_root": .bool(false),
            "created_at": .date(date),
            "updated_at": .date(date),
        ])
        let updated = MockDatabaseRow([
            "id": .string("identity-1"),
            "name": .string("Ada Lovelace"),
            "status": .string("active"),
            "is_root": .bool(false),
            "created_at": .date(date),
            "updated_at": .date(date),
        ])
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(key: .find, rows: [existing]),
                .init(key: .update),
                .init(key: .updated, rows: [updated]),
                .init(key: .roleIDs),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .put,
            path: "/api/v1/admin/user/identities/identity-1",
            body: Components.Schemas.UserIdentityUpdateSchema(
                name: "Ada Lovelace",
                status: .active,
                roleIds: []
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
        #expect(json["id"] as? String == "identity-1")
        #expect(json["name"] as? String == "Ada Lovelace")
        #expect(json["status"] as? String == "active")
        try await connection.assertAllResponsesConsumed()
    }
}
