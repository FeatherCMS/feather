import AnalyticsAdminAPI
import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing

@Suite
struct LogQueryTests {
    @Test
    func returnsSearchResponseFromGeneratedAPI() async throws {
        let context = try AnalyticsAPIHTTPTestSupport.makeContext()
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/analytics/logs/query",
            body: Components.Schemas
                .AnalyticsLogQueryItemSearchRequestQuerySchema(
                    filters: .init()
                )
        )

        let body = try await AnalyticsAPIHTTPTestSupport.send(
            request,
            using: context.executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        let data = try #require(json["data"] as? [String: Any])

        #expect(data["total"] as? Int == 0)
        try await context.connection.assertAllResponsesConsumed()
    }
}
