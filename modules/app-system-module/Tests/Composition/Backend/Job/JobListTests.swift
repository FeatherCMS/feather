import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct JobListTests {
    private enum QueryKey: DatabaseQueryKey {
        case jobList
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
    func returnsJobs() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(key: .jobList, rows: [jobRow()])
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/system/jobs?pageSize=10&pageNumber=1"
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let items = try array(from: body)
        #expect(items.first?["id"] as? String == "job-1")
        #expect(items.first?["queueName"] as? String == "default")
        #expect(items.first?["payload"] as? String == "{}")
        try await connection.assertAllResponsesConsumed()
    }
}
