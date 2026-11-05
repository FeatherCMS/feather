import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariableListTests {
    private enum QueryKey: DatabaseQueryKey {
        case variableList
    }

    private func array(from body: String) throws -> [[String: Any]] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
    }

    private func variableRow() -> MockDatabaseRow {
        .init([
            "id": .string("variable-1"),
            "key": .string("mail.from"),
            "value": .string("noreply@example.test"),
            "name": .null,
            "notes": .null,
        ])
    }

    @Test
    func returnsFilteredDatabaseResults() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .variableList,
                    rows: [variableRow()]
                )
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path:
                "/api/v1/admin/system/variables?search=mail&ids=variable-1&ids=variable-2&limit=7"
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try array(from: body)
        #expect(items.count == 1)
        #expect(items.first?["id"] as? String == "variable-1")
        #expect(items.first?["key"] as? String == "mail.from")
        #expect(items.first?["value"] as? String == "noreply@example.test")
        try await connection.assertAllResponsesConsumed()
    }
}
