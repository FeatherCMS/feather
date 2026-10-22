import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import Testing

@Suite
struct ProfileCurrentUserTests {
    private enum QueryKey: DatabaseQueryKey {
        case detail
    }

    @Test
    func returnsCurrentProfileThroughAdminAPI() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [Self.profileResponse]
        )
        let executor = try AccountAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/account/profile"
        )

        let body = try await AccountAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let profile = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        #expect(profile["firstName"] as? String == "Ada")
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func returnsCurrentProfileThroughAppAPI() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [Self.profileResponse]
        )
        let executor = try AccountAPIHTTPTestSupport.makeAppExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/account/profile"
        )

        let body = try await AccountAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let profile = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        #expect(profile["firstName"] as? String == "Ada")
        try await connection.assertAllResponsesConsumed()
    }

    private static var profileResponse: MockDatabaseConnection<QueryKey>.Response {
        .init(
            key: .detail,
            rows: [
                .init([
                    "id": .string("profile-1"),
                    "user_id": .string("admin-1"),
                    "first_name": .string("Ada"),
                    "last_name": .string("Lovelace"),
                    "profile_image_asset_id": .null,
                    "created_at": .date(
                        Date(timeIntervalSince1970: 1_700_000_000)
                    ),
                    "updated_at": .date(
                        Date(timeIntervalSince1970: 1_700_000_000)
                    ),
                ])
            ]
        )
    }
}
