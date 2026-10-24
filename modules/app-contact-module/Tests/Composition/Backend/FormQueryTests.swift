import ContactAdminAPI
import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import Testing

@Suite
struct FormQueryTests {
    @Test
    func returnsSearchResultsFromGeneratedAPI() async throws {
        let context = try ContactAPIHTTPTestSupport.makeContext()
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/contact/form/query",
            body: Components.Schemas
                .ContactFormQueryItemSearchRequestQuerySchema(
                    page: .init(size: 150, number: 0),
                    filters: .init(search: "contact")
                )
        )

        let body = try await ContactAPIHTTPTestSupport.send(
            request,
            using: context.executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        let query = try #require(json["query"] as? [String: Any])
        let page = try #require(query["page"] as? [String: Any])
        let data = try #require(json["data"] as? [String: Any])
        let items = try #require(data["items"] as? [[String: Any]])

        #expect(page["size"] as? Int == 100)
        #expect(page["number"] as? Int == 1)
        #expect(data["total"] as? Int == 1)
        #expect(items.first?["key"] as? String == "contact")
        #expect(items.first?["name"] as? String == "Contact us")
        try await context.connection.assertAllResponsesConsumed()
    }
}
