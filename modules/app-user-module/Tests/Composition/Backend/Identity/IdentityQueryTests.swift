import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct IdentityQueryTests {
    private enum QueryKey: DatabaseQueryKey {
        case search
        case roles
        case count
    }

    @Test
    func returnsSearchResultsAndTotal() async throws {
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
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/user/identities/query",
            body: Components.Schemas
                .UserIdentityQueryItemSearchRequestQuerySchema(
                    page: .init(size: 20, number: 1),
                    filters: .init(search: "Ada", role: "admin")
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
        let data = try #require(json["data"] as? [String: Any])
        #expect(data["total"] as? Int == 1)
        let items = try #require(data["items"] as? [[String: Any]])
        #expect(items.first?["id"] as? String == "identity-1")
        #expect(items.first?["roles"] as? [String] == ["admin"])
        try await connection.assertAllResponsesConsumed()
    }
}
