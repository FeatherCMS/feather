//import FeatherSpec
//import FeatherSpecHummingbird
//import FeatherMail
//import FeatherMailEphemeral
//import HTTPTypes
//import Logging
//import AdminOpenAPI
//import Testing
//#if canImport(FoundationEssentials)
//import FoundationEssentials
//#else
//import Foundation
//#endif
//
//@Suite
//struct UserAuthTestSuite {
//
//    private func check(
//        _ testBlock:
//            @Sendable @escaping (SpecRunnerHummingbird, MailClientEphemeral)
//            async throws -> Void
//    ) async throws {
//        var logger = Logger(label: "server-auth-tests")
//        logger.logLevel = .info
//        let testDatabase = await TestDatabase.shared(logger: logger)
//
//        try await testDatabase.createNew { database in
//            let mailClient = MailClientEphemeral()
//            let app = try await buildTestServer(
//                database: database,
//                config: testingConfig(),
//                mailClient: mailClient
//            )
//            let runner = SpecRunnerHummingbird(app: app)
//            try await testBlock(runner, mailClient)
//        }
//    }
//
//    private func extractSessionToken(from setCookie: String) -> String? {
//        let decoded = setCookie.removingPercentEncoding ?? setCookie
//
//        for key in ["session_token=", "session="] {
//            guard let range = decoded.range(of: key) else {
//                continue
//            }
//            let suffix = decoded[range.upperBound...]
//            if let end = suffix.firstIndex(of: ";") {
//                return String(suffix[..<end])
//            }
//            return String(suffix)
//        }
//        return nil
//    }
//
//    // MARK: - App Auth
//
//    @Test
//    func loginAppAuth() async throws {
//        try await check { runner, _ in
//            try await runner.run {
//                Method(.post)
//                Path("api/v1/user/auth/login")
//                JSONRequest(
//                    Components.Schemas.UserAuthLoginRequestSchema(
//                        email: "user@example.com",
//                        password: "user",
//                        isPersistent: true
//                    )
//                )
//                Expect(.setCookie) { value in
//                    #expect(!value.isEmpty)
//                    #expect(self.extractSessionToken(from: value) != nil)
//                }
//                JSONResponse<Components.Schemas.UserAuthMeResponseSchema>(
//                    status: .ok
//                ) { payload in
//                    #expect(payload.user.email == "user@example.com")
//                }
//            }
//        }
//    }
//
//    @Test
//    func linkAppAuth() async throws {
//        try await check { runner, mailClient in
//            try await runner.run {
//                Method(.post)
//                Path("api/v1/user/auth/magic-link")
//                JSONRequest(
//                    Components.Schemas.UserAuthMagicLinkRequestSchema(
//                        email: "user@example.com",
//                        isPersistent: true
//                    )
//                )
//                Expect(.noContent)
//            }
//
//            let messages = await mailClient.getMailbox()
//            #expect(
//                messages.contains(where: {
//                    let bodyText: String
//                    switch $0.body {
//                    case let .plainText(value):
//                        bodyText = value
//                    case let .html(value):
//                        bodyText = value
//                    }
//                    return $0.subject == "Application - Sign In Link"
//                        && $0.to.contains(where: {
//                            $0.email == "user@example.com"
//                        })
//                        && !bodyText.contains("[LINK]")
//                        && !bodyText.trimmingCharacters(
//                            in: .whitespacesAndNewlines
//                        )
//                        .isEmpty
//                })
//            )
//        }
//    }
//
//    @Test
//    func verifyAppAuthMagicLink() async throws {
//        try await check { runner, _ in
//            try await runner.run {
//                Method(.post)
//                Path("api/v1/admin/user/magic-links")
//                Header(.cookie, "session_token=root-session-token")
//                JSONRequest(
//                    AdminOpenAPI.Components.Schemas
//                        .UserMagicLinkCreateSchema(
//                            email: "user@example.com",
//                            isPersistent: true
//                        )
//                )
//                JSONResponse<
//                    AdminOpenAPI.Components.Schemas
//                        .UserMagicLinkDetailSchema
//                >(
//                    status: .created
//                ) { detail in
//                    #expect(detail.email == "user@example.com")
//                    #expect(!detail.token.isEmpty)
//
//                    try await runner.run {
//                        Method(.post)
//                        Path("api/v1/user/auth/magic-link/verify")
//                        JSONRequest(
//                            Components.Schemas
//                                .UserAuthMagicLinkVerifyRequestSchema(
//                                    token: detail.token
//                                )
//                        )
//                        Expect(.setCookie) { value in
//                            #expect(!value.isEmpty)
//                            #expect(
//                                self.extractSessionToken(from: value) != nil
//                            )
//                        }
//                        JSONResponse<
//                            Components.Schemas.UserAuthMeResponseSchema
//                        >(
//                            status: .ok
//                        ) { payload in
//                            #expect(payload.user.email == "user@example.com")
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    //    @Test
//    //    func registerAppAuth() async throws {
//    //        try await check { runner, _ in
//    //            let email =
//    //                "register-\(UUID().uuidString.lowercased())@example.com"
//    //
//    //            try await runner.run {
//    //                Method(.post)
//    //                Path("api/v1/user/auth/register")
//    //                JSONRequest(
//    //                    Components.Schemas.UserAuthRegisterSchema(
//    //                        email: email,
//    //                        password: "register-password-123"
//    //                    )
//    //                )
//    //                JSONResponse<Components.Schemas.UserAuthMeResponseSchema>(
//    //                    status: .created
//    //                ) { payload in
//    //                    #expect(payload.user.email == email)
//    //                    #expect(!payload.user.id.isEmpty)
//    //                }
//    //            }
//    //        }
//    //    }
//
//    @Test
//    func logoutAppAuth() async throws {
//        try await check { runner, _ in
//            let tokenStore = ValueStore("")
//
//            try await runner.run {
//                Method(.post)
//                Path("api/v1/user/auth/login")
//                JSONRequest(
//                    Components.Schemas.UserAuthLoginRequestSchema(
//                        email: "user@example.com",
//                        password: "user",
//                        isPersistent: true
//                    )
//                )
//                Expect(.setCookie) { value in
//                    let token = self.extractSessionToken(from: value) ?? ""
//                    #expect(!token.isEmpty)
//                    await tokenStore.set(token)
//                }
//                JSONResponse<Components.Schemas.UserAuthMeResponseSchema>(
//                    status: .ok
//                ) { payload in
//                    #expect(payload.user.email == "user@example.com")
//                }
//            }
//
//            let token = await tokenStore.get()
//            #expect(!token.isEmpty)
//
//            try await runner.run {
//                Method(.post)
//                Path("api/v1/user/auth/logout")
//                Header(.cookie, "session_token=\(token)")
//                Expect(.noContent)
//            }
//        }
//    }
//}
