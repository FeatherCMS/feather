import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AuthAdminAPI

@testable import Server

@Suite
struct AdminAPIUserAuthLoginTests {

    @Test
    func adminSignInWithCredentialsIsOk() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        let email = "mail.tib@gmail.com"
        let pass = "root"
        let isPersistent = true
        let body = Components.Schemas.AuthLoginRequestSchema(
            email: email,
            password: pass,
            isPersistent: isPersistent
        )
        let request = JSONRequest(
            method: .post,
            path: "/api/v1/admin/auth/login",
            body: body
        )

        try await runner.run(
            request: request
        ) { response -> Components.Schemas.AuthResponseSchema in
            let object = try await response.json(
                Components.Schemas.AuthResponseSchema.self
            )
            #expect(object.user.email == email)
            return object
        }
    }
}
