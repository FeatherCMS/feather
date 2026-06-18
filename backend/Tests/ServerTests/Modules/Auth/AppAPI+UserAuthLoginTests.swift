import FeatherHTTP
import HTTPTypes
import OpenAPIRuntime
import Testing

import AppOpenAPI

@testable import Server

@Suite
struct AppAPIUserAuthLoginTests {

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
                path: "/api/v1/auth/login",
                body: Components.Schemas.AuthLoginRequestSchema(
                    email: email,
                    password: pass,
                    isPersistent: isPersistent
                )
            )
        ) { response in
            let object = try await response.json(
                Components.Schemas.AuthResponseSchema.self
            )
            #expect(object.user.email == email)
        }
    }

    @Test
    func signInWithCredentialsAndGetProfile() async throws {
        let runner = try await TestRunner()
        try await runner.setupMigratedDatabase()

        let email = "mail.tib@gmail.com"
        let pass = "root"
        let isPersistent = true

        let loginResponse = try await runner.run(
            request: JSONRequest(
                method: .post,
                path: "/api/v1/auth/login",
                body: Components.Schemas.AuthLoginRequestSchema(
                    email: email,
                    password: pass,
                    isPersistent: isPersistent
                )
            )
        ) { response in
            try await response.json(
                Components.Schemas.AuthResponseSchema.self
            )
        }

        let response = try await runner.run(
            request: JSONRequest(
                method: .get,
                path: "/api/v1/auth/me",
                headerFields: [
                    .authorization: "Bearer \(loginResponse.token)"
                ],
                body: ""
            )
        ) { response in
            try await response.json(
                Components.Schemas.AuthResponseSchema.self
            )
        }

        #expect(response.user.email == email)
    }
}
