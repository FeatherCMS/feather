import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RoleListTests {
    private enum QueryKey: DatabaseQueryKey {
        case search
        case count
    }

    @Test
    func returnsSimpleRoleList() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .search,
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
                ),
                .init(key: .count, rows: [.init(["count": .int(1)])]),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/user/roles?limit=100"
        )

        let body = try await UserAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
        #expect(items.count == 1)
        #expect(items.first?["id"] as? String == "role-admin")
        #expect(items.first?["key"] as? String == "user.admin")
        try await connection.assertAllResponsesConsumed()
    }
}
