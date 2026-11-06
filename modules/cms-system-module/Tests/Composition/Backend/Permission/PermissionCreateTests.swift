import FeatherDatabaseTesting
import FeatherHTTP
import Foundation
import HTTPTypes
import SystemAdminAPI
import Testing

@Suite
struct PermissionCreateTests {
    private enum QueryKey: DatabaseQueryKey {
        case permissionCreate
    }

    private func object(from body: String) throws -> [String: Any] {
        try #require(
            JSONSerialization.jsonObject(with: Data(body.utf8))
                as? [String: Any]
        )
    }

    @Test
    func createsPermission() async throws {
        let connection = MockDatabaseConnection<
            QueryKey
        >(
            responses: [.init(key: .permissionCreate)]
        )
        let executor = try SystemAPIHTTPTestSupport.makeExecutor(
            connection: connection
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/system/permissions",
            body: Components.Schemas.SystemPermissionCreateSchema(
                key: "system.test",
                name: "Test permission",
                notes: "Created over HTTP"
            )
        )

        let body = try await SystemAPIHTTPTestSupport.send(
            request,
            expectedStatus: 201,
            using: executor
        )
        let json = try object(from: body)
        #expect(json["id"] as? String == "created-1")
        #expect(json["key"] as? String == "system.test")
        #expect(json["name"] as? String == "Test permission")
        try await connection.assertAllResponsesConsumed()
    }
}
