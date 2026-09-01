//
//  AuthApplicationTestSuite.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import SystemApplication
import Testing

import struct Foundation.Date

@testable import AuthApplication
@testable import AuthDomain
@testable import UserDomain

@Suite
struct AuthApplicationTestSuite {

    @Test
    func addMagicLinkSuccess() async throws {
        let repo = MockMagicLinkRepository(result: makeMagicLink(id: "m-1"))
        let transaction = MockTransactionExecutor(
            context: WriteMagicLink(magicLink: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(credentialId: "credential-1", isPersistent: true)
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
            context: WriteCredentialLink(credential: repository)
        )
        let useCase = AddCredential(
            authorizer: MockAuthorizer(result: true),
            transaction: transaction,
            passwordHasher: MockPasswordHasher()
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(
                userId: credential.userId,
                email: credential.email,
                password: "password-123"
            )
        )

        #expect(result.userId == credential.userId)
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
            context: WriteRequestMagicLink(
                credential: credentialRepository,
                magicLink: magicLinkRepository,
                variable: MockVariableQueries(value: "https://example.test")
            )
        )
        let mailSender = MockMailSender()
        let useCase = RequestMagicLink(
            transaction: transaction,
            mailSender: mailSender
        )

        let sent = try await useCase.execute(
            .init(email: credential.email, isPersistent: true)
        )

        #expect(sent)
        #expect(await magicLinkRepository.insertCallCount == 1)
        #expect(await mailSender.sendCallCount == 1)
        #expect(
            await mailSender.lastMessage?.body.contains("user@example.com")
                == true
        )
        #expect(
            await mailSender.lastMessage?.body
                .contains("https://example.test/magic-link/verify/") == true
        )
    }

    @Test
    func signInWithMagicLinkConsumesLinkAndCreatesSession() async throws {
        let credential = makeCredential()
        let identity = makeIdentity()
        let magicLinkRepository = MockMagicLinkRepository(
            result: makeMagicLink(id: "m-sign-in")
        )
        let sessionRepository = MockAuthSessionRepository()
        let transaction = MockTransactionExecutor(
            context: WriteAuth(
                identity: MockAuthIdentityRepository(identity: identity),
                credential: MockCredentialRepository(result: credential),
                session: sessionRepository,
                magicLink: magicLinkRepository
            )
        )
        let useCase = SignInWithMagicLink(transaction: transaction)

        let result = try await useCase.execute(.init(token: "valid-token"))

        #expect(result.user.id == identity.id)
        #expect(result.session.identityId == identity.id)
        #expect(
            result.session.authenticationType
                == Session.AuthenticationTypes.magicLink
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
            context: WriteAuth(
                identity: MockAuthIdentityRepository(),
                credential: MockCredentialRepository(result: makeCredential()),
                session: MockAuthSessionRepository(),
                magicLink: magicLinkRepository
            )
        )
        let useCase = SignInWithMagicLink(transaction: transaction)

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
            context: ReadMagicLink(magicLink: queries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = ListMagicLinks(
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
            context: ReadMagicLink(magicLink: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListMagicLinks(
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
            context: ReadMagicLink(magicLink: queries)
        )
        let useCase = ListMagicLinks(
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
            context: WriteMagicLink(magicLink: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RemoveMagicLink(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: .init(id: "m-2")
        )

        #expect(deleted)
        #expect(await repo.deleteCallCount == 1)
    }

    @Test
    func addRolePermissionSuccess() async throws {
        let repo = MockRolePermissionRepository(result: makeRolePermission())
        let transaction = MockTransactionExecutor(
            context: WriteRolePermissions(rolePermissions: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddRolePermission(
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
            context: AuthScope(
                identity: DummyIdentityQueries(),
                rolePermissions: rpQueries
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListRolePermissions(
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
            context: WriteRolePermissions(rolePermissions: repo)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RemoveRolePermission(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-7"),
                input: .init(roleId: "role-1", permissionId: "perm-1")
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
            context: WriteSession(session: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ExtendSession(
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
            context: ReadSession(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = ListSessions(
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
            context: ReadSession(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListIdentitySessions(
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
            context: ReadSession(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = GetSession(
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
            context: WriteSession(session: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RemoveSession(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-10"),
            input: .init(id: "s-1")
        )

        #expect(deleted)
        #expect(await repo.deleteCallCount == 1)
    }
}

private func makeMagicLink(
    id: String
) -> MagicLink {
    .init(
        id: id,
        credentialId: "credential-1",
        token: "valid-token",
        expiresAt: Date().addingTimeInterval(3600),
        isPersistent: true,
        isUsed: false,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeCredential() -> Credential {
    .init(
        id: "credential-1",
        userId: "identity-1",
        email: "user@example.com",
        passwordHash: "password-hash",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeIdentity() -> Identity {
    .init(
        id: "identity-1",
        status: .active,
        isRoot: false,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRolePermission() -> RolePermission {
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
) -> Session {
    .init(
        id: id,
        token: token,
        identityId: "identity-1",
        authenticationType: Session.AuthenticationTypes.credential,
        authenticationReference: "credential-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSessionListItem(
    identityId: String
) -> SessionList.Item {
    .init(
        id: "session-1",
        token: "token-1",
        identityId: identityId,
        authenticationType: Session.AuthenticationTypes.credential,
        authenticationReference: "credential-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSessionDetail(
    identityId: String
) -> SessionDetail {
    .init(
        id: "session-1",
        token: "token-1",
        identityId: identityId,
        authenticationType: Session.AuthenticationTypes.credential,
        authenticationReference: "credential-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}
