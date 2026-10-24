import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import MediaAdminAPI
import Testing

@Suite
struct VariantQueryHTTPTests {
    private enum QueryKey: DatabaseQueryKey {
        case variantList
    }

    @Test
    func returnsVariantQueryEnvelope() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .variantList)]
        )
        let executor = try MediaAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/media/variants/query",
            body: Components.Schemas
                .MediaVariantQueryItemSearchRequestQuerySchema(
                    filters: .init()
                )
        )

        let body = try await MediaAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        let data = try #require(json["data"] as? [String: Any])
        #expect(data["total"] as? Int == 0)
        #expect((data["items"] as? [Any])?.isEmpty == true)
        try await connection.assertAllResponsesConsumed()
    }
}
