import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct VariableDeleteTests {
    private enum QueryKey: DatabaseQueryKey {
        case variableDelete
    }

    @Test
    func deletesSelectedVariables() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [.init(key: .variableDelete)]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .delete,
            path: "/api/v1/admin/system/variables",
            body: Components.Schemas.DeleteRequestSchema(ids: ["variable-1"])
        )

        _ = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 204,
            using: executor
        )
        try await connection.assertAllResponsesConsumed()
    }
}
