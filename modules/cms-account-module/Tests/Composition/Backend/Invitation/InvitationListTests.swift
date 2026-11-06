import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing

@Suite
struct InvitationListTests {
    private enum QueryKey: DatabaseQueryKey {
        case list
    }

    @Test
    func returnsInvitationListOverHTTP() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .list,
                    rows: [
                        .init([
                            "id": .string("invitation-1"),
                            "user_id": .string("user-1"),
                            "email": .string("ada@example.com"),
                            "token": .string("token-1"),
                            "role_ids": .string("[\"role-admin\"]"),
                            "expires_at": .date(date),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                )
            ]
        )
        let executor = try AccountAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/account/invitations"
        )

        let body = try await AccountAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
        #expect(items.count == 1)
        #expect(items.first?["id"] as? String == "invitation-1")
        #expect(items.first?["email"] as? String == "ada@example.com")
        try await connection.assertAllResponsesConsumed()
    }
}
