import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariableGetTests {
    private enum QueryKey: DatabaseQueryKey {
        case variableFind
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
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
    func returnsVariableByID() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .variableFind,
                    rows: [variableRow()]
                )
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/system/variables/variable-1"
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "variable-1")
        #expect(json["key"] as? String == "mail.from")
        #expect(json["value"] as? String == "noreply@example.test")
        try await connection.assertAllResponsesConsumed()
    }
}
