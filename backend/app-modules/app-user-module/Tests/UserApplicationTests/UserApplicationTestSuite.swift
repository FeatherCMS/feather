import Testing
import Application
import Domain
import struct Foundation.Date
import UserDomain
@testable import UserApplication

@Suite
struct UserApplicationTestSuite {

    @Test
    func addAccountSuccess() async throws {
        let accountRepo = MockAccountRepository(result: makeAccount(id: "a-1"))
        let roleRepo = MockRoleRepository(result: makeRole(id: "r-1"))
        let transaction = MockTransactionExecutor(
            context: WriteAccount(account: accountRepo, role: roleRepo)
        )
        let authorizer = MockAuthorizer(result: true)
        let passwordHasher = MockPasswordHasher(hashResult: "hashed")
        let useCase = AddAccount(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id"),
            passwordHasher: passwordHasher
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(
                email: "john@example.com",
                password: "long-enough-password"
            )
        )

        #expect(result.id == "a-1")
        #expect(await authorizer.canCallCount == 1)
        #expect(await accountRepo.createCallCount == 1)
        #expect(await passwordHasher.hashCallCount == 1)
    }

    @Test
    func getMyAccountForbiddenForAnotherUser() async throws {
        let queries = MockAccountQueries(
            detailResult: makeAccountDetail(id: "a-2"),
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadAccount(account: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = GetMyAccount(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-2"),
                input: .init(id: "another-user")
            )
        }
        #expect(await queryExecutor.runCallCount == 0)
    }

    @Test
    func listAccountsForbidden() async throws {
        let queries = MockAccountQueries(
            detailResult: makeAccountDetail(id: "a-3"),
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadAccount(account: queries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = ListAccounts(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-3"),
                input: .init(query: .init())
            )
        }
        #expect(await queryExecutor.runCallCount == 0)
    }

    @Test
    func addRoleSuccess() async throws {
        let roleRepo = MockRoleRepository(result: makeRole(id: "r-2"))
        let transaction = MockTransactionExecutor(
            context: WriteRole(role: roleRepo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddRole(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-role-id")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: .init(name: "Manager", notes: "can manage things")
        )

        #expect(result.id == "r-2")
        #expect(await roleRepo.createCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func listRolesAndCountSuccess() async throws {
        let queries = MockRoleQueries(
            detailResult: makeRoleDetail(id: "r-3"),
            listResult: .init(items: []),
            countResult: 7
        )
        let queryExecutor = MockQueryExecutor(context: ReadRole(role: queries))
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListRoles(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: .init(query: .init())
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-5"),
            input: .init(query: .init())
        )

        #expect(list.items.count == 0)
        #expect(count == 7)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func removeRoleForbidden() async throws {
        let roleRepo = MockRoleRepository(
            result: makeRole(id: "r-4"),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteRole(role: roleRepo)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RemoveRole(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-6"),
                input: .init(id: "r-4")
            )
        }
        #expect(await roleRepo.deleteCallCount == 0)
    }

    @Test
    func addInvitationSuccess() async throws {
        let repo = MockInvitationRepository(result: makeInvitation(id: "i-1"))
        let transaction = MockTransactionExecutor(
            context: WriteInvitation(invitation: repo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddInvitation(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-inv-id")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-7"),
            input: .init(email: "invitee@example.com")
        )

        #expect(result.id == "i-1")
        #expect(await repo.createCallCount == 1)
    }

    @Test
    func listInvitationsAndCountSuccess() async throws {
        let queries = MockInvitationQueries(
            listResult: .init(items: []),
            countResult: 5
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadInvitation(invitation: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListInvitations(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-8"),
            input: .init(query: .init())
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-8"),
            input: .init(query: .init())
        )

        #expect(list.items.count == 0)
        #expect(count == 5)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func removeInvitationForbidden() async throws {
        let repo = MockInvitationRepository(
            result: makeInvitation(id: "i-2"),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteInvitation(invitation: repo)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RemoveInvitation(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-9"),
                input: .init(id: "i-2")
            )
        }
        #expect(await repo.deleteCallCount == 0)
    }
}

private func makeAccount(
    id: String
) -> Account {
    .init(
        id: id,
        email: "user@example.com",
        passwordHash: "hashed",
        status: .pending,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRole(
    id: String
) -> Role {
    .init(
        id: id,
        name: "Role \(id)",
        notes: "Notes \(id)",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeInvitation(
    id: String
) -> Invitation {
    .init(
        id: id,
        email: "invitee@example.com",
        token: "token-\(id)",
        expiresAt: Date().addingTimeInterval(3600),
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeAccountDetail(
    id: String
) -> AccountDetail {
    .init(
        id: id,
        email: "detail@example.com",
        status: .pending,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRoleDetail(
    id: String
) -> RoleDetail {
    .init(
        id: id,
        name: "Detail \(id)",
        notes: "Detail notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}
