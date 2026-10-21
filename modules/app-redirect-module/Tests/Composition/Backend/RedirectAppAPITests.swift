import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing

@Suite
struct RedirectAppAPITests {
    private enum QueryKey: DatabaseQueryKey {
        case resolve
    }

    @Test
    func resolvesRootRedirect() async throws {
        let timestamp = Date(timeIntervalSince1970: 1_800_000_000)
        let row = MockDatabaseRow([
            "id": .string("redirect-root"),
            "source": .string("/"),
            "destination": .string("/home"),
            "status_code": .int(301),
            "notes": .null,
            "created_at": .date(timestamp),
            "updated_at": .date(timestamp),
        ])
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .resolve, rows: [row])]
        )
        let executor = try RedirectAPIHTTPTestSupport.makeAppExecutor(
            connection: connection
        )
        let body = try await RedirectAPIHTTPTestSupport.send(
            Request(
                method: .get,
                path: "/api/v1/redirect/rules?source=%2F"
            ),
            expectedStatus: 200,
            using: executor
        )
        let value = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8)) as? [String: Any]
        )

        #expect(value["source"] as? String == "/")
        #expect(value["destination"] as? String == "/home")
        #expect(value["statusCode"] as? Int == 301)
        try await connection.assertAllResponsesConsumed()
    }
}
