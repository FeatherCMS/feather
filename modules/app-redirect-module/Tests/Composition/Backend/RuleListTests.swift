import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing

@Suite
struct RuleListTests {
    private enum QueryKey: DatabaseQueryKey {
        case list
    }

    @Test
    func returnsRedirectRuleList() async throws {
        let timestamp = Date(timeIntervalSince1970: 1_800_000_000)
        let row = MockDatabaseRow([
            "id": .string("redirect-1"),
            "source": .string("/old"),
            "destination": .string("/new"),
            "status_code": .int(301),
            "notes": .null,
            "created_at": .date(timestamp),
            "updated_at": .date(timestamp),
        ])
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .list, rows: [row])]
        )
        let executor = try RedirectAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let body = try await RedirectAPIHTTPTestSupport.send(
            Request(method: .get, path: "/api/v1/admin/redirect/rules"),
            expectedStatus: 200,
            using: executor
        )
        let values = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8)) as? [[String: Any]]
        )

        #expect(values.count == 1)
        #expect(values.first?["id"] as? String == "redirect-1")
        #expect(values.first?["source"] as? String == "/old")
        #expect(values.first?["destination"] as? String == "/new")
        try await connection.assertAllResponsesConsumed()
    }
}
