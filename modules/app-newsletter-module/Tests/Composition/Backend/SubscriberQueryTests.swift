import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import NewsletterAdminAPI
import Testing

@Suite
struct SubscriberQueryTests {
    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    @Test
    func queryReturnsSearchResultsAndNormalizedPage() async throws {
        let context = try NewsletterAPIHTTPTestSupport.makeContext()
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/newsletter/subscribers/query",
            body: Components.Schemas
                .NewsletterSubscriberQueryItemSearchRequestQuerySchema(
                    page: .init(size: 25, number: 2),
                    sort: [
                        .init(field: .email, direction: .asc)
                    ],
                    filters: .init(search: "person", campaignKey: "weekly")
                )
        )

        let body = try await NewsletterAPIHTTPTestSupport.send(
            request,
            using: context.executor
        )
        let json = try object(from: body)
        let query = try #require(json["query"] as? [String: Any])
        let page = try #require(query["page"] as? [String: Any])
        #expect(page["size"] as? Int == 25)
        #expect(page["number"] as? Int == 2)
        let sort = try #require(query["sort"] as? [[String: Any]])
        #expect(sort.first?["field"] as? String == "email")
        let data = try #require(json["data"] as? [String: Any])
        #expect(data["total"] as? Int == 1)
        let items = try #require(data["items"] as? [[String: Any]])
        #expect(items.first?["email"] as? String == "person@example.com")
        #expect(items.first?["name"] as? String == "Test Person")
        let queries = await context.connection.executedQueries()
        #expect(
            queries[.search]?.first?.sql
                .contains("ORDER BY email ASC") == true
        )
        try await context.connection.assertAllResponsesConsumed()
    }
}
