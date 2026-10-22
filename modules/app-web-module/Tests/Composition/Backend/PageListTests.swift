import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing
import WebAdminAPI

@Suite
struct PageListTests {
    private enum QueryKey: DatabaseQueryKey {
        case pageList
    }

    @Test
    func returnsPagesFromDatabase() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .pageList,
                    rows: [
                        .init([
                            "id": .string("page-home"),
                            "title": .string("Home"),
                            "excerpt": .string("Home page"),
                            "image_asset_id": .null,
                            "created_at": .date(.now),
                            "updated_at": .date(.now),
                        ])
                    ]
                )
            ]
        )
        let executor = try WebAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/web/pages/"
        )

        let body = try await WebAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
        #expect(items.count == 1)
        #expect(items.first?["id"] as? String == "page-home")
        #expect(items.first?["title"] as? String == "Home")
        try await connection.assertAllResponsesConsumed()
    }
}
