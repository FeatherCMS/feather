import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariableCreateTests {
    private enum QueryKey: DatabaseQueryKey {
        case variableCreate
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    @Test
    func createsVariable() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [.init(key: .variableCreate)]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/system/variables",
            body: Components.Schemas.SystemVariableCreateSchema(
                key: "mail.from",
                value: "noreply@example.test",
                name: "Mail from"
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 201,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "created-1")
        #expect(json["key"] as? String == "mail.from")
        #expect(json["value"] as? String == "noreply@example.test")
        try await connection.assertAllResponsesConsumed()
    }
}
