import FeatherHTTP
import HTTPTypes
import Testing

@testable import Server

@Suite
struct AdminAPISystemPermissionGetTests {

    @Test
    func missingPermissionReturnsNotFound() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "system:permissions:read"
        ])
        let token = try await runner.authenticateTestAccount()

        try await runner.run(
            request: Request(
                method: .get,
                path: "/api/v1/admin/system/permissions/missing-permission",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ]
            )
        ) { response in
            #expect(response.response.status == .notFound)
        }
    }
}
