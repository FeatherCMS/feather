import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import WebAdminAPI

@Suite
struct MenuListTests {
    private enum QueryKey: DatabaseQueryKey {
        case menuList
    }

    private func array(from body: String) throws -> [[String: Any]] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
    }

    @Test
    func returnsMenusFromDatabase() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .menuList,
                    rows: [
                        .init([
                            "id": .string("menu-1"),
                            "key": .string("primary"),
                            "name": .string("Primary navigation"),
                            "created_at": .date(.now),
                            "updated_at": .date(.now),
                        ])
                    ]
                )
            ]
        )
        let executor = try APIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/web/menus/"
        )

        let body = try await APIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try array(from: body)
        #expect(items.count == 1)
        #expect(items.first?["id"] as? String == "menu-1")
        #expect(items.first?["key"] as? String == "primary")
        #expect(items.first?["name"] as? String == "Primary navigation")
        try await connection.assertAllResponsesConsumed()
    }
}
