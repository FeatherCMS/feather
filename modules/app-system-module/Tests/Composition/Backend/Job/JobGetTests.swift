import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct JobGetTests {
    private enum QueryKey: DatabaseQueryKey {
        case jobGet
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
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
    func returnsJobByID() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [
                .init(key: .jobGet, rows: [jobRow()])
            ]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = FeatherHTTP.Request(
            method: .get,
            path: "/api/v1/admin/system/jobs/job-1"
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 200,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "job-1")
        #expect(json["queueName"] as? String == "default")
        #expect(json["status"] as? Int == 1)
        try await connection.assertAllResponsesConsumed()
    }
}
