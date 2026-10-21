import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityListTests {
    private enum QueryKey: DatabaseQueryKey {
        case search
        case roles
        case count
    }

    @Test
    func returnsSimpleIdentityList() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .search,
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
                .init(key: .roles, rows: [.init(["name": .string("admin")])]),
                .init(key: .count, rows: [.init(["count": .int(1)])]),
            ]
        )
        let executor = try UserAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path:
                "/api/v1/admin/user/identities?search=Ada&role=admin&limit=100"
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
        #expect(items.first?["id"] as? String == "identity-1")
        #expect(items.first?["name"] as? String == "Ada Lovelace")
        #expect(items.first?["roles"] as? [String] == ["admin"])
        try await connection.assertAllResponsesConsumed()
    }
}
