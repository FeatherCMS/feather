import Testing
import Application
import AuthDomain
import struct Foundation.Date
@testable import AuthApplication

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
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(email: "hello@example.com", isPersistent: true)
        )

        #expect(result.id == "m-1")
        #expect(await repo.insertCallCount == 1)
        #expect(await authorizer.canCallCount == 1)
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
                account: DummyAccountQueries(),
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
    func listAccountSessionsScopesQueryToAccount() async throws {
        let sessionQueries = MockSessionQueries(
            listResult: .init(
                items: [makeSessionListItem(accountId: "account-1")]
            )
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadSession(session: sessionQueries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListAccountSessions(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-10"),
            input: .init(accountId: "account-1")
        )

        #expect(result.items.count == 1)
        #expect(await sessionQueries.lastQuery?.accountId == "account-1")
    }

    @Test
    func getSessionSuccess() async throws {
        let sessionQueries = MockSessionQueries(
            findResult: makeSessionDetail(accountId: "account-1"),
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
        #expect(result.accountId == "account-1")
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
        email: "hello@example.com",
        token: "valid-token",
        expiresAt: Date().addingTimeInterval(3600),
        isPersistent: true,
        isUsed: false,
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
        accountId: "account-1",
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSessionListItem(
    accountId: String
) -> SessionList.Item {
    .init(
        id: "session-1",
        token: "token-1",
        accountId: accountId,
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeSessionDetail(
    accountId: String
) -> SessionDetail {
    .init(
        id: "session-1",
        token: "token-1",
        accountId: accountId,
        expiresAt: 123_456,
        isPersistent: true,
        createdAt: Date(),
        updatedAt: Date()
    )
}
