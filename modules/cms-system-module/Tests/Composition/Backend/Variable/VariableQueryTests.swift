import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariableQueryTests {
    private enum QueryKey: DatabaseQueryKey {
        case variableList
        case variableCount
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
    func returnsFilteredResultsAndCount() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(key: .variableList, rows: [variableRow()]),
                .init(key: .variableCount, rows: [.init(["count": .int(1)])]),
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/system/variables/query",
            body: Components.Schemas
                .SystemVariableQueryItemSearchRequestQuerySchema(
                    page: .init(size: 150, number: 0),
                    filters: .init(search: "mail")
                )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        let query = try #require(json["query"] as? [String: Any])
        let page = try #require(query["page"] as? [String: Any])
        #expect(page["size"] as? Int == 100)
        #expect(page["number"] as? Int == 1)
        let data = try #require(json["data"] as? [String: Any])
        #expect(data["total"] as? Int == 1)
        let items = try #require(data["items"] as? [[String: Any]])
        #expect(items.first?["key"] as? String == "mail.from")
        #expect(items.first?["value"] as? String == "noreply@example.test")
        try await connection.assertAllResponsesConsumed()
    }

    @Test
    func defaultsPageWhenPageValuesAreOmitted() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(
                    key: .variableList,
                    rows: [variableRow()]
                ),
                .init(key: .variableCount, rows: [.init(["count": .int(1)])]),
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/system/variables/query",
            body: Components.Schemas
                .SystemVariableQueryItemSearchRequestQuerySchema(
                    page: nil,
                    filters: .init()
                )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let query = try #require(
            object(from: body)["query"]
                as? [String: Any]
        )
        let page = try #require(query["page"] as? [String: Any])
        #expect(page["size"] as? Int == 20)
        #expect(page["number"] as? Int == 1)
        try await connection.assertAllResponsesConsumed()
    }
}
