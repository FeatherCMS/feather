import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

@testable import Server

@Suite
struct AdminAPISystemVariableCreateTests {

    @Test
    func createSystemVariableIsCreatedForAuthorizedUser() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()
        try await runner.grantRootPermissions([
            "system:variables:create"
        ])
        let token = try await runner.authenticateTestAccount()

        let name = "foo-bar"
        let value = "bar"
        let notes = "baz"
        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/system/variables",
                headerFields: [
                    .authorization: runner.bearerAuthorizationHeader(
                        token: token
                    )
                ],
                body: Components.Schemas.SystemVariableCreateSchema(
                    name: name,
                    value: value,
                    notes: notes
                )
            )
        ) { response in
            let object = try await response.json(
                status: .created,
                Components.Schemas.SystemVariableDetailSchema.self
            )
            #expect(object.name == name)
            #expect(object.value == value)
            #expect(object.notes == notes)
        }
    }
}
