import AuthAdminAPI
import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing

@Suite
struct AuthEmailQueryTests {
    private enum QueryKey: DatabaseQueryKey {
        case authEmailList
        case authEmailCount
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    @Test
    func returnsSearchItemsAndTotalOverHTTP() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .authEmailList,
                    rows: [
                        .init([
                            "id": .string("email-1"),
                            "identity_id": .string("identity-1"),
                            "email": .string("user@example.test"),
                            "created_at": .date(
                                Date(timeIntervalSince1970: 1_700_000_000)
                            ),
                            "updated_at": .date(
                                Date(timeIntervalSince1970: 1_700_000_000)
                            ),
                        ])
                    ]
                ),
                .init(
                    key: .authEmailCount,
                    rows: [.init(["count": .int(3)])]
                ),
            ]
        )
        let executor = try AuthAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/auth/emails/query",
            body: Components.Schemas
                .AuthEmailQuerySchemasItemSearchRequestQuerySchema(
                    page: .init(size: 50, number: 1),
                    filters: .init(search: "user", identityId: "identity-1")
                )
        )

        let body = try await AuthAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        let data = try #require(json["data"] as? [String: Any])
        let items = try #require(data["items"] as? [[String: Any]])
        #expect(data["total"] as? Int == 3)
        #expect(items.first?["id"] as? String == "email-1")
        #expect(items.first?["identityId"] as? String == "identity-1")
        #expect(items.first?["email"] as? String == "user@example.test")
        try await connection.assertAllResponsesConsumed()
    }
}
