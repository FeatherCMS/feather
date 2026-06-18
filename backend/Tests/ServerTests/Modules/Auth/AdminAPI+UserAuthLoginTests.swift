import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AdminOpenAPI

@testable import Server

@Suite
struct AdminAPIUserAuthLoginTests {

    @Test
    func signInWithCredentialsIsOk() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        let email = "mail.tib@gmail.com"
        let pass = "root"
        let isPersistent = true

        try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/admin/user/auth/login",
                body: Components.Schemas.UserAuthLoginRequestSchema(
                    email: email,
                    password: pass,
                    isPersistent: isPersistent
                )
            )
        ) { response in
            let object = try await response.json(
                Components.Schemas.UserAuthMeResponseSchema.self
            )
            #expect(object.user.email == email)
        }
    }
}
