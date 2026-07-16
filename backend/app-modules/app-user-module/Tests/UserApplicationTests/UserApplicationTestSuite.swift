//
//  UserApplicationTestSuite.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import Domain
import Testing
import UserDomain

import struct Foundation.Date

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
        let passwordHasher = MockPasswordHasher(hashResult: "hashed-password")
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
        let accountRepo = MockAccountRepository(result: makeAccount(id: "a-1"))
        let roleRepo = MockRoleRepository(result: makeRole(id: "r-1"))
        let transaction = MockTransactionExecutor(
            context: WriteInvitation(
                invitation: repo,
                account: accountRepo,
                role: roleRepo
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddInvitation(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-inv-id"),
            passwordHasher: MockPasswordHasher()
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-7"),
            input: .init(email: "invitee@example.com")
        )

        #expect(result.id == "i-1")
        #expect(await repo.createCallCount == 1)
    }

    @Test
    func addInvitationCreatesInvitedAccountAndAssignsRoles() async throws {
        let invitationRepo = MockInvitationRepository(
            result: makeInvitation(id: "i-invited", accountID: "generated-id")
        )
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "generated-id")
        )
        let roleRepo = MockRoleRepository(
            result: makeRole(id: "r-invited"),
            findResult: makeRole(id: "r-invited")
        )
        let transaction = MockTransactionExecutor(
            context: WriteInvitation(
                invitation: invitationRepo,
                account: accountRepo,
                role: roleRepo
            )
        )
        let useCase = AddInvitation(
            authorizer: MockAuthorizer(result: true),
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id"),
            passwordHasher: MockPasswordHasher(hashResult: "hashed-password")
        )

        _ = try await useCase.execute(
            subject: Subject(id: "subject-invited"),
            input: .init(email: "invitee@example.com", roleIDs: ["r-invited"])
        )

        #expect(await transaction.runCallCount == 1)
        #expect(await accountRepo.createCallCount == 1)
        #expect(await accountRepo.insertedModel?.id == "generated-id")
        #expect(await accountRepo.insertedModel?.status == .invited)
        #expect(await accountRepo.replaceRoleIdsCallCount == 1)
        #expect(await accountRepo.replacedRoleIds == ["r-invited"])
        #expect(await invitationRepo.createCallCount == 1)
        #expect(await invitationRepo.insertedModel?.accountID == "generated-id")
    }

    @Test
    func addInvitationRejectsUnknownRole() async throws {
        let invitationRepo = MockInvitationRepository(
            result: makeInvitation(id: "i-role-error")
        )
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "a-role-error")
        )
        let roleRepo = MockRoleRepository(result: makeRole(id: "r-role-error"))
        let transaction = MockTransactionExecutor(
            context: WriteInvitation(
                invitation: invitationRepo,
                account: accountRepo,
                role: roleRepo
            )
        )
        let useCase = AddInvitation(
            authorizer: MockAuthorizer(result: true),
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id"),
            passwordHasher: MockPasswordHasher()
        )

        await #expect(throws: AddInvitation.Error.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-role-error"),
                input: .init(
                    email: "invitee@example.com",
                    roleIDs: ["missing-role"]
                )
            )
        }

        #expect(await accountRepo.replaceRoleIdsCallCount == 0)
        #expect(await invitationRepo.createCallCount == 0)
    }

    @Test
    func completeInvitationRegistrationActivatesAccountAndConsumesInvitation()
        async throws
    {
        let invitation = makeInvitation(
            id: "i-complete",
            accountID: "a-complete"
        )
        let invitationRepo = MockInvitationRepository(
            result: invitation,
            findByTokenResult: invitation,
            deleteResult: true
        )
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "a-complete"),
            findByIdResult: makeAccount(id: "a-complete", status: .invited)
        )
        let transaction = MockTransactionExecutor(
            context: WriteInvitation(
                invitation: invitationRepo,
                account: accountRepo,
                role: MockRoleRepository(result: makeRole(id: "r-complete"))
            )
        )
        let useCase = CompleteInvitationRegistration(
            transaction: transaction,
            passwordHasher: MockPasswordHasher(
                hashResult: "completed-password-hash"
            )
        )

        let result = try await useCase.execute(
            input: .init(
                token: invitation.token,
                password: "completed-password"
            )
        )

        #expect(result.id == "a-complete")
        #expect(await accountRepo.updateCallCount == 1)
        #expect(await invitationRepo.deleteCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func completeInvitationRegistrationRejectsExpiredInvitation() async throws {
        let invitation = makeInvitation(
            id: "i-expired",
            expiresAt: Date().addingTimeInterval(-60)
        )
        let invitationRepo = MockInvitationRepository(
            result: invitation,
            findByTokenResult: invitation,
            deleteResult: true
        )
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "i-expired"),
            findByIdResult: makeAccount(id: "i-expired", status: .invited)
        )
        let useCase = CompleteInvitationRegistration(
            transaction: MockTransactionExecutor(
                context: WriteInvitation(
                    invitation: invitationRepo,
                    account: accountRepo,
                    role: MockRoleRepository(result: makeRole(id: "r-expired"))
                )
            ),
            passwordHasher: MockPasswordHasher()
        )

        await #expect(throws: Invitation.Error.expired) {
            _ = try await useCase.execute(
                input: .init(
                    token: invitation.token,
                    password: "completed-password"
                )
            )
        }

        #expect(await accountRepo.updateCallCount == 0)
        #expect(await invitationRepo.deleteCallCount == 0)
    }

    @Test
    func completeInvitationRegistrationRejectsInvalidToken() async throws {
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "a-invalid-token"),
            findByIdResult: makeAccount(id: "a-invalid-token", status: .invited)
        )
        let invitationRepo = MockInvitationRepository(
            result: makeInvitation(id: "i-invalid-token")
        )
        let useCase = CompleteInvitationRegistration(
            transaction: MockTransactionExecutor(
                context: WriteInvitation(
                    invitation: invitationRepo,
                    account: accountRepo,
                    role: MockRoleRepository(
                        result: makeRole(id: "r-invalid-token")
                    )
                )
            ),
            passwordHasher: MockPasswordHasher()
        )

        await #expect(throws: CompleteInvitationRegistration.Error.self) {
            _ = try await useCase.execute(
                input: .init(
                    token: "missing-token",
                    password: "completed-password"
                )
            )
        }
        #expect(await accountRepo.updateCallCount == 0)
    }

    @Test
    func completeInvitationRegistrationRejectsAlreadyUsedInvitation()
        async throws
    {
        let invitation = makeInvitation(id: "i-used")
        let invitationRepo = MockInvitationRepository(
            result: invitation,
            findByTokenResult: invitation,
            deleteResult: false
        )
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "a-used"),
            findByIdResult: makeAccount(id: "a-used", status: .invited)
        )
        let useCase = CompleteInvitationRegistration(
            transaction: MockTransactionExecutor(
                context: WriteInvitation(
                    invitation: invitationRepo,
                    account: accountRepo,
                    role: MockRoleRepository(result: makeRole(id: "r-used"))
                )
            ),
            passwordHasher: MockPasswordHasher()
        )

        await #expect(throws: CompleteInvitationRegistration.Error.self) {
            _ = try await useCase.execute(
                input: .init(
                    token: invitation.token,
                    password: "completed-password"
                )
            )
        }
        #expect(await accountRepo.updateCallCount == 1)
    }

    @Test
    func completeInvitationRegistrationRejectsNonInvitedAccount() async throws {
        let invitation = makeInvitation(
            id: "i-inactive",
            accountID: "a-inactive"
        )
        let invitationRepo = MockInvitationRepository(
            result: invitation,
            findByTokenResult: invitation
        )
        let accountRepo = MockAccountRepository(
            result: makeAccount(id: "a-inactive"),
            findByIdResult: makeAccount(id: "a-inactive", status: .inactive)
        )
        let useCase = CompleteInvitationRegistration(
            transaction: MockTransactionExecutor(
                context: WriteInvitation(
                    invitation: invitationRepo,
                    account: accountRepo,
                    role: MockRoleRepository(result: makeRole(id: "r-inactive"))
                )
            ),
            passwordHasher: MockPasswordHasher()
        )

        await #expect(throws: CompleteInvitationRegistration.Error.self) {
            _ = try await useCase.execute(
                input: .init(
                    token: invitation.token,
                    password: "completed-password"
                )
            )
        }
        #expect(await accountRepo.updateCallCount == 0)
        #expect(await invitationRepo.deleteCallCount == 0)
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
    id: String,
    status: Account.Status = .pending
) -> Account {
    .init(
        id: id,
        email: "user@example.com",
        passwordHash: "hashed",
        status: status,
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
    id: String,
    accountID: String? = nil,
    expiresAt: Date = Date().addingTimeInterval(3600)
) -> Invitation {
    .init(
        id: id,
        accountID: accountID ?? id,
        email: "invitee@example.com",
        token: "token-\(id)",
        expiresAt: expiresAt,
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
