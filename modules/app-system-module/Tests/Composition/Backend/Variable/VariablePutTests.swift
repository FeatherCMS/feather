import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariablePutTests {
    private enum QueryKey: DatabaseQueryKey {
        case variableFind
        case variableUpdate
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
    func replacesVariableFields() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .variableFind,
                    rows: [variableRow()]
                ),
                .init(key: .variableUpdate),
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .put,
            path: "/api/v1/admin/system/variables/variable-1",
            body: Components.Schemas.SystemVariableCreateSchema(
                key: "mail.reply-to",
                value: "support@example.test",
                name: "Reply to",
                notes: "Support mailbox"
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["key"] as? String == "mail.reply-to")
        #expect(json["value"] as? String == "support@example.test")
        #expect(json["name"] as? String == "Reply to")
        try await connection.assertAllResponsesConsumed()
    }
}
