import FeatherDatabase
import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct JobListTests {
    private enum QueryKey: DatabaseQueryKey {
        case jobSearch
        case jobCount
    }

    private func array(from body: String) throws -> [[String: Any]] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [[String: Any]]
        )
    }

    private func jobRow() -> MockDatabaseRow {
        .init([
            "id": .string("job-1"),
            "queue_name": .string("default"),
            "status": .int(1),
            "worker_id": .null,
            "last_modified": .date(Date(timeIntervalSince1970: 1_700_000_000)),
            "payload": .string("{}"),
        ])
    }

    @Test
    func searchesJobsWithStatusFilterAndPagination() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(key: .jobSearch, rows: [jobRow()]),
                .init(key: .jobCount, rows: [.init(["count": .int(1)])]),
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/system/jobs/query",
            body: Components.Schemas.SystemJobSearchRequestQuerySchema(
                page: .init(size: 10, number: 2),
                sort: [
                    .init(field: .queuedAt, direction: .desc)
                ],
                filters: .init(search: "worker", status: 1)
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
        let query = try #require(json["query"] as? [String: Any])
        let page = try #require(query["page"] as? [String: Any])
        #expect(page["size"] as? Int == 10)
        #expect(page["number"] as? Int == 2)
        let data = try #require(json["data"] as? [String: Any])
        #expect(data["total"] as? Int == 1)
        let items = try #require(data["items"] as? [[String: Any]])
        #expect(items.first?["id"] as? String == "job-1")

        let queries = await connection.executedQueries()
        #expect(
            queries[.jobSearch]?.first?.sql.contains("LIMIT") == true
        )
        #expect(
            queries[.jobSearch]?.first?.sql.contains("ILIKE") == true
        )
        #expect(
            queries[.jobCount]?.first?.sql.contains("COUNT(*)") == true
        )
        try await connection.assertAllResponsesConsumed()
    }
}
