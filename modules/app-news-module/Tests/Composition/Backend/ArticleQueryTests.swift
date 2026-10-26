import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import NewsAdminAPI
import Testing

@Suite
struct ArticleQueryTests {
    @Test
    func returnsSearchResultsFromGeneratedAPI() async throws {
        let context = try NewsAPIHTTPTestSupport.makeContext()
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/news/articles/query",
            body: Components.Schemas
                .NewsArticleQueryItemSearchRequestQuerySchema(
                    page: .init(size: 20, number: 1),
                    filters: .init(search: "Swift")
                )
        )

        let body = try await NewsAPIHTTPTestSupport.send(
            request,
            using: context.executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        let data = try #require(json["data"] as? [String: Any])
        let items = try #require(data["items"] as? [[String: Any]])

        #expect(data["total"] as? Int == 1)
        #expect(items.first?["id"] as? String == "article-1")
        #expect(items.first?["title"] as? String == "Swift release")
        try await context.connection.assertAllResponsesConsumed()
    }
}
