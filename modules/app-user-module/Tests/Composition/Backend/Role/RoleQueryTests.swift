import FeatherDatabase
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
                    page: .init(size: 500, number: .max),
                    sort: [
                        .init(field: .name, direction: .asc),
                        .init(field: .notes, direction: .desc),
                    ],
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
        let query = try #require(json["query"] as? [String: Any])
        let page = try #require(query["page"] as? [String: Any])
        #expect(page["size"] as? Int == 100)
        #expect(page["number"] as? Int == .max)
        let sort = try #require(query["sort"] as? [[String: Any]])
        #expect(sort.map { $0["field"] as? String } == ["name", "notes"])
        #expect(data["total"] as? Int == 1)
        let items = try #require(data["items"] as? [[String: Any]])
        #expect(items.first?["id"] as? String == "role-admin")
        #expect(items.first?["key"] as? String == "user.admin")
        #expect(items.first?["notes"] == nil || items.first?["notes"] is NSNull)
        let queries = await connection.executedQueries()
        let searchQuery = try #require(queries[.search]?.first)
        #expect(
            searchQuery.sql.contains(
                "ORDER BY \"name\" ASC, \"notes\" DESC, \"id\" ASC"
            )
        )
        #expect(searchQuery.sql.contains("LIMIT 100"))
        #expect(searchQuery.sql.contains("OFFSET \(Int.max)"))
        try await connection.assertAllResponsesConsumed()
    }
}
