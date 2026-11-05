import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityGetTests {

    private enum QueryKey: DatabaseQueryKey {
        case find
        case roleIDs
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    @Test
    func returnsIdentityAndRoleIDs() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("identity-1"),
                            "name": .string("Ada Lovelace"),
                            "status": .string("active"),
                            "is_root": .bool(false),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                ),
                .init(
                    key: .roleIDs,
                    rows: [
                        .init(["role_id": .string("role-admin")])
                    ]
                ),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/user/identities/identity-1"
        )

        let body = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "identity-1")
        #expect(json["name"] as? String == "Ada Lovelace")
        #expect(json["status"] as? String == "active")
        #expect(json["roleIds"] as? [String] == ["role-admin"])
        try await connection.assertAllResponsesConsumed()
    }
}
