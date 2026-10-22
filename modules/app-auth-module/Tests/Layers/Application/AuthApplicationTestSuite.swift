import AuthModule
import FeatherApplication
import FeatherMail
import FeatherModuleKit
import SystemApplication
import Testing
import UserModule

import struct Foundation.Date

@testable import AuthApplication
@testable import AuthDomain
@testable import UserDomain

//
//  AuthApplicationTestSuite.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

@Suite
struct AuthApplicationTestSuite {

    @Test
    func searchAuthEmailsReturnsItemsAndTotal() async throws {
        let query = MockAuthEmailSearchQuery(
            result: .init(
                items: [
                    .init(
                        id: "email-1",
                        identityId: "identity-1",
                        email: "user@example.test"
                    )
                ],
                total: 4
            )
        )
        let executor = MockQueryExecutor(
            context: Email.Search.Scope(authEmail: query)
        )
        let useCase = Email.Search.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                query: .init(
                    search: "user",
                    identityId: "identity-1"
                )
            )
        )

        #expect(result.items.map(\.email) == ["user@example.test"])
        #expect(result.total == 4)
        #expect(await query.searchCallCount == 1)
        #expect(await query.lastQuery?.identityId == "identity-1")
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func searchAuthEmailsRejectsForbiddenSubject() async throws {
        let query = MockAuthEmailSearchQuery(result: .init(items: [], total: 0))
        let useCase = Email.Search.UseCase(
            authorizer: MockAuthorizer(result: false),
            query: MockQueryExecutor(
                context: Email.Search.Scope(authEmail: query)
            )
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "unauthorized"),
                input: .init(query: .init())
            )
        }
        #expect(await query.searchCallCount == 0)
    }

    @Test
    func addMagicLinkSuccess() async throws {
        let repo = MockMagicLinkRepository(result: makeMagicLink(id: "m-1"))
        let transaction = MockTransactionExecutor(
            context: MagicLink.Add.Scope(magicLink: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = MagicLink.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(authEmailId: "auth-email-1", isPersistent: true)
        )

        #expect(result.id == "m-1")
        #expect(await repo.insertCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func addCredentialPersistsHashedPasswordWithoutPersistenceField()
        async throws
    {
        let credential = makeCredential()
        let repository = MockCredentialRepository(result: credential)
        let transaction = MockTransactionExecutor(
            context: Credential.Add.Scope(
                credential: repository,
                authEmail: MockAuthEmailRepository(
                    result: makeAuthEmail(identityId: "identity-1")
                )
            )
        )
        let useCase = Credential.Add.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: transaction,
            passwordHasher: MockPasswordHasher()
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                userId: "identity-1",
                email: "user@example.com",
                password: "password-123"
            )
        )

        #expect(result.userId == "identity-1")
        #expect(await repository.insertCallCount == 1)
        #expect(
            await repository.insertedModel?.passwordHash
                == "hashed-password-123"
        )
    }

    @Test
    func requestMagicLinkSendsConfiguredTemplate() async throws {
        let credential = makeCredential()
        let credentialRepository = MockCredentialRepository(result: credential)
        let magicLinkRepository = MockMagicLinkRepository(
            result: makeMagicLink(id: "m-request")
        )
        let transaction = MockTransactionExecutor(
            context: MagicLink.Request.Scope(
                credential: credentialRepository,
                authEmail: MockAuthEmailRepository(
                    result: makeAuthEmail(identityId: "identity-1")
                ),
                magicLink: magicLinkRepository,
                variable: MockVariableLookup(
                    value: "https://example.test",
                    mailFromAddress: "magic-links@example.test",
                    mailFromName: "Binary Birds"
                )
            )
        )
        let jobs = MockSendMailJobController()
        let useCase = MagicLink.Request.UseCase(
            transaction: transaction,
            jobs: jobs
        )

        let sent = try await useCase.execute(
            .init(email: "user@example.com", isPersistent: true)
        )

        #expect(sent)
        #expect(await magicLinkRepository.insertCallCount == 1)
        #expect(await jobs.enqueueCallCount == 1)
        #expect(
            await jobs.lastMail?.from.email
                == "magic-links@example.test"
        )
        #expect(await jobs.lastMail?.from.name == "Binary Birds")
        #expect(
            await jobs.lastBody?.contains("user@example.com")
                == true
        )
        #expect(
            await jobs.lastBody?
                .contains("https://example.test/magic-link/verify/") == true
        )
    }

    @Test
    func signInWithMagicLinkConsumesLinkAndCreatesSession() async throws {
        let identity = makeIdentity()
        let magicLinkRepository = MockMagicLinkRepository(
            result: makeMagicLink(id: "m-sign-in")
        )
        let sessionRepository = MockAuthSessionRepository()
        let transaction = MockTransactionExecutor(
            context: AuthModule.Authorization.SignIn.MagicLink.Scope(
                identity: MockAuthIdentityRepository(identity: identity),
                authorization: DummyAuthorizationQueries(),
                authEmail: MockAuthEmailRepository(
                    result: makeAuthEmail(identityId: identity.id)
                ),
                magicLink: magicLinkRepository,
                session: sessionRepository
            )
        )
        let useCase = AuthModule.Authorization.SignIn.MagicLink.UseCase(
            transaction: transaction
        )

        let result = try await useCase.execute(.init(token: "valid-token"))

        #expect(result.user.id == identity.id)
        #expect(result.session.identityId == identity.id)
        #expect(
            result.session.authenticationType
                == Session.Model.AuthenticationTypes.magicLink
        )
        #expect(result.session.authenticationReference == "m-sign-in")
        #expect(result.roles == ["editor"])
        #expect(result.permissions == ["account:read"])
        #expect(await magicLinkRepository.consumeCallCount == 1)
        #expect(await magicLinkRepository.consumedToken == "valid-token")
    }

    @Test
    func signInWithInvalidMagicLinkReturnsAuthenticationError() async throws {
        let magicLinkRepository = MockMagicLinkRepository(
            result: makeMagicLink(id: "m-invalid"),
            consumeError: .alreadyUsed
        )
        let transaction = MockTransactionExecutor(
            context: AuthModule.Authorization.SignIn.MagicLink.Scope(
                identity: MockAuthIdentityRepository(),
                authorization: DummyAuthorizationQueries(),
                authEmail: MockAuthEmailRepository(
                    result: makeAuthEmail(identityId: "identity-1")
                ),
                magicLink: magicLinkRepository,
                session: MockAuthSessionRepository()
            )
        )
        let useCase = AuthModule.Authorization.SignIn.MagicLink.UseCase(
            transaction: transaction
        )

        await #expect(throws: UseCaseError.self) {
            _ = try await useCase.execute(.init(token: "used-token"))
        }
    }

    @Test
    func listMagicLinksForbidden() async throws {
        let queries = MockMagicLinkQueries(
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: MagicLink.List.Scope(magicLink: queries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = MagicLink.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-2"),
                input: .init(query: .init())
            )
        }
        #expect(await queryExecutor.runCallCount == 0)
    }

    @Test
    func listMagicLinksCountSuccess() async throws {
        let queries = MockMagicLinkQueries(
            listResult: .init(items: []),
            countResult: 4
        )
        let queryExecutor = MockQueryExecutor(
            context: MagicLink.List.Scope(magicLink: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = MagicLink.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let count = try await useCase.count(
            subject: Subject(id: "subject-3"),
            input: .init(query: .init())
        )

        #expect(count == 4)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func listMagicLinksPreservesUserFilter() async throws {
        let queries = MockMagicLinkQueries(
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: MagicLink.List.Scope(magicLink: queries)
        )
        let useCase = MagicLink.List.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: queryExecutor
        )

        _ = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: .init(query: .init(userId: "user-4"))
        )

        #expect(await queries.lastListQuery?.userId == "user-4")
    }

    @Test
    func removeMagicLinkSuccess() async throws {
        let repo = MockMagicLinkRepository(
            result: makeMagicLink(id: "m-2"),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: MagicLink.Remove.Scope(magicLink: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = MagicLink.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: .init(ids: ["m-2"])
        )

        #expect(deleted == ["m-2"])
        #expect(await repo.deleteCallCount == 1)
    }

    @Test
    func addRolePermissionSuccess() async throws {
        let repo = MockRolePermissionRepository(result: makeRolePermission())
        let transaction = MockTransactionExecutor(
            context: RolePermission.Add.Scope(rolePermissions: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RolePermission.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: .init(roleId: "role-1", permissionId: "perm-1")
        )

        #expect(result.roleId == "role-1")
        #expect(await repo.insertCallCount == 1)
    }

    @Test
    func listRolePermissionsAndCountSuccess() async throws {
        let rpQueries = MockRolePermissionQueries(
            listResult: .init(items: []),
            countResult: 2
        )
        let queryExecutor = MockQueryExecutor(
            context: RolePermission.Search.Scope(
                authorization: DummyAuthorizationQueries(),
                rolePermissions: rpQueries
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RolePermission.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-6"),
            input: .init(query: .init())
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-6"),
            input: .init(query: .init())
        )

        #expect(list.items.count == 0)
        #expect(count == 2)
        #expect(await rpQueries.listCallCount == 1)
        #expect(await rpQueries.countCallCount == 1)
    }

    @Test
    func removeRolePermissionForbidden() async throws {
        let repo = MockRolePermissionRepository(result: makeRolePermission())
        let transaction = MockTransactionExecutor(
            context: RolePermission.Remove.Scope(rolePermissions: repo)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RolePermission.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-7"),
                input: .init(ids: ["role-permission-1"])
            )
        }
        #expect(await repo.deleteCallCount == 0)
    }

    @Test
    func extendSessionSuccess() async throws {
        let repo = MockSessionRepository(
            tokenFindResult: makeSession(id: "s-1", token: "token-1")
        )
        let transaction = MockTransactionExecutor(
            context: Session.Extend.Scope(session: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Session.Extend.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let extended = try await useCase.execute(
            subject: Subject(id: "subject-8"),
            input: .init(token: "token-1", expiresAt: 999_999)
        )

        #expect(extended)
        #expect(await repo.updateCallCount == 1)
    }

    @Test
    func listSessionsForbidden() async throws {
        let sessionQueries = MockSessionQueries(listResult: .init(items: []))
        let queryExecutor = MockQueryExecutor(
            context: Session.List.Scope(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = Session.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-9"),
                input: .init(query: .init())
            )
        }
        #expect(await sessionQueries.listCallCount == 0)
    }

    @Test
    func listIdentitySessionsScopesQueryToIdentity() async throws {
        let sessionQueries = MockSessionQueries(
            listResult: .init(
                items: [makeSessionListItem(identityId: "identity-1")]
            )
        )
        let queryExecutor = MockQueryExecutor(
            context: Session.ListByIdentity.Scope(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Session.ListByIdentity.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-10"),
            input: .init(identityId: "identity-1")
        )

        #expect(result.items.count == 1)
        #expect(await sessionQueries.lastQuery?.identityId == "identity-1")
    }

    @Test
    func getSessionSuccess() async throws {
        let sessionQueries = MockSessionQueries(
            findResult: makeSessionDetail(identityId: "identity-1"),
            listResult: .init(items: [])
        )
        let queryExecutor = MockQueryExecutor(
            context: Session.Detail.Scope(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Session.Detail.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-10"),
            input: .init(id: "session-1")
        )

        #expect(result.id == "session-1")
        #expect(result.identityId == "identity-1")
        #expect(await sessionQueries.findCallCount == 1)
    }

    @Test
    func removeSessionSuccess() async throws {
        let repo = MockSessionRepository(deleteResult: true)
        let transaction = MockTransactionExecutor(
            context: Session.Remove.Scope(session: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Session.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-10"),
            input: .init(ids: ["s-1"])
        )

        #expect(deleted == ["s-1"])
        #expect(await repo.deleteCallCount == 1)
    }
}

private func makeMagicLink(
    id: String
) -> MagicLink.Model {
    .init(
        id: id,
        authEmailId: "auth-email-1",
        token: "valid-token",
        expiresAt: Date().addingTimeInterval(3600),
        isPersistent: true,
        isUsed: false,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeCredential() -> Credential.Model {
    .init(
        id: "credential-1",
        authEmailId: "auth-email-1",
        passwordHash: "password-hash",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeAuthEmail(
    identityId: String
) -> Email.Model {
    .init(
        id: "auth-email-1",
        identityId: identityId,
        email: "user@example.com",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeIdentity() -> Identity.Model {
    .init(
        id: "identity-1",
        status: .active,
        isRoot: false,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRolePermission() -> RolePermission.Model {
    .init(
        roleId: "role-1",
        permissionId: "perm-1",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSession(
    id: String,
    token: String
) -> Session.Model {
    .init(
        id: id,
        token: token,
        identityId: "identity-1",
        authenticationType: Session.Model.AuthenticationTypes
            .credential,
        authenticationReference: "credential-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSessionListItem(
    identityId: String
) -> Session.List.Output.Item {
    .init(
        id: "session-1",
        token: "token-1",
        identityId: identityId,
        authenticationType: Session.Model.AuthenticationTypes
            .credential,
        authenticationReference: "credential-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSessionDetail(
    identityId: String
) -> Session.Detail.Output {
    .init(
        id: "session-1",
        token: "token-1",
        identityId: identityId,
        authenticationType: Session.Model.AuthenticationTypes
            .credential,
        authenticationReference: "credential-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}
