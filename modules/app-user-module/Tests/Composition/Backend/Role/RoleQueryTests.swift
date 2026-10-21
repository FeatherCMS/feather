import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import UserAdminAPI

@Suite
struct RoleQueryTests {
    private enum QueryKey: DatabaseQueryKey {
        case search
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
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/user/roles/query",
            body: Components.Schemas
                .UserRoleQueryItemSearchRequestQuerySchema(
                    page: .init(size: 20, number: 1),
                    filters: .init(search: "admin")
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
        #expect(items.first?["id"] as? String == "role-admin")
        #expect(items.first?["key"] as? String == "user.admin")
        try await connection.assertAllResponsesConsumed()
    }
}
