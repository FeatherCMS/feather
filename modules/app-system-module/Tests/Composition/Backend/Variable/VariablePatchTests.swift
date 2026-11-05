import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariablePatchTests {
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
    func appliesUpdateMask() async throws {
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
            method: .patch,
            path: "/api/v1/admin/system/variables/variable-1?updateMask=value",
            body: Components.Schemas.SystemVariablePatchSchema(
                value: "support@example.test"
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["key"] as? String == "mail.from")
        #expect(json["value"] as? String == "support@example.test")
        try await connection.assertAllResponsesConsumed()
    }
}
