import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RoleGetTests {

    private enum QueryKey: DatabaseQueryKey {
        case find
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    @Test
    func returnsRoleByID() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("role-admin"),
                            "key": .string("user.admin"),
                            "name": .string("Administrator"),
                            "notes": .null,
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                )
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/user/roles/role-admin"
        )

        let body = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "role-admin")
        #expect(json["key"] as? String == "user.admin")
        #expect(json["name"] as? String == "Administrator")
        #expect(json["notes"] == nil)
        try await connection.assertAllResponsesConsumed()
    }
}
