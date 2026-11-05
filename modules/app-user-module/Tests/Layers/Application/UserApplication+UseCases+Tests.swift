//
//  UserApplication+UseCases+Tests.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import Testing
import UserDomain
import UserModule

import struct Foundation.Date

@testable import UserApplication

@Suite
struct UserApplicationUseCasesTests {

    @Test
    func addIdentitySuccess() async throws {
        let identityRepo = MockIdentityRepository(
            result: makeIdentity(id: "a-1")
        )
        let roleRepo = MockRoleRepository(result: makeRole(id: "r-1"))
        let events = MockEventPublisher()
        let transaction = MockTransactionExecutor(
            context: Identity.Add.Scope(
                identity: identityRepo,
                role: roleRepo
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Identity.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction,
            events: events
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(
                status: .invited
            )
        )

        #expect(result.id == "a-1")
        #expect(await authorizer.canCallCount == 1)
        #expect(await identityRepo.createCallCount == 1)
        #expect(await events.triggerCallCount == 1)
        #expect(await events.identityIDs == ["a-1"])
    }

    @Test
    func addIdentityForbidden() async throws {
        let repository = MockIdentityRepository(result: makeIdentity(id: "i-0"))
        let transaction = MockTransactionExecutor(
            context: Identity.Add.Scope(
                identity: repository,
                role: MockRoleRepository(result: makeRole(id: "r-0"))
            )
        )
        let useCase = Identity.Add.UseCase(
            authorizer: MockAuthorizer(result: false),
            transaction: transaction,
            events: MockEventPublisher()
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-add-identity-forbidden"),
                input: .init(status: .invited)
            )
        }
        #expect(await transaction.runCallCount == 0)
        #expect(await repository.createCallCount == 0)
    }

    @Test
    func detailIdentitySuccess() async throws {
        let query = TestIdentityDetailQuery(
            result: makeIdentityDetail(id: "i-1")
        )
        let executor = MockQueryExecutor(
            context: Identity.Detail.Scope(identity: query)
        )
        let useCase = Identity.Detail.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-identity-detail"),
            input: .init(id: "i-1")
        )

        #expect(result.id == "i-1")
        #expect(await query.requestedID == "i-1")
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func detailIdentityForbidden() async throws {
        let query = TestIdentityDetailQuery(
            result: makeIdentityDetail(id: "i-1")
        )
        let executor = MockQueryExecutor(
            context: Identity.Detail.Scope(identity: query)
        )
        let useCase = Identity.Detail.UseCase(
            authorizer: MockAuthorizer(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-identity-detail"),
                input: .init(id: "i-1")
            )
        }
        #expect(await executor.runCallCount == 0)
    }

    @Test
    func detailRoleSuccess() async throws {
        let query = TestRoleDetailQuery(result: makeRoleDetail(id: "r-1"))
        let executor = MockQueryExecutor(
            context: Role.Detail.Scope(role: query)
        )
        let useCase = Role.Detail.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-role-detail"),
            input: .init(id: "r-1")
        )

        #expect(result.id == "r-1")
        #expect(await query.requestedID == "r-1")
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func detailRoleForbidden() async throws {
        let executor = MockQueryExecutor(
            context: Role.Detail.Scope(
                role: TestRoleDetailQuery(result: makeRoleDetail(id: "r-1"))
            )
        )
        let useCase = Role.Detail.UseCase(
            authorizer: MockAuthorizer(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-role-detail"),
                input: .init(id: "r-1")
            )
        }
        #expect(await executor.runCallCount == 0)
    }

    @Test
    func listIdentitiesSuccessAndForbidden() async throws {
        let item = Identity.List.Output.Item(
            id: "i-2",
            name: "Identity",
            status: .active,
            roles: ["admin"]
        )
        let query = TestIdentityListQuery(
            result: .init(items: [item])
        )
        let executor = MockQueryExecutor(
            context: Identity.List.Scope(identity: query)
        )
        let useCase = Identity.List.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: executor
        )
        let input = Identity.List.Input(query: .init(search: "identity"))

        let result = try await useCase.execute(
            subject: Subject(id: "subject-identity-list"),
            input: input
        )
        #expect(result.items.map(\.id) == ["i-2"])
        #expect(await query.lastQuery?.search == "identity")

        let forbiddenExecutor = MockQueryExecutor(
            context: Identity.List.Scope(identity: query)
        )
        let forbiddenUseCase = Identity.List.UseCase(
            authorizer: MockAuthorizer(result: false),
            query: forbiddenExecutor
        )
        await #expect(throws: AuthError.self) {
            _ = try await forbiddenUseCase.execute(
                subject: Subject(id: "subject-identity-list"),
                input: input
            )
        }
        #expect(await forbiddenExecutor.runCallCount == 0)
    }

    @Test
    func listRolesSuccessAndForbidden() async throws {
        let query = TestRoleListQuery(
            result: .init(items: [
                .init(id: "r-2", key: "editor", name: "Editor")
            ])
        )
        let executor = MockQueryExecutor(context: Role.List.Scope(role: query))
        let useCase = Role.List.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: executor
        )
        let input = Role.List.Input(query: .init(search: "edit"))

        let result = try await useCase.execute(
            subject: Subject(id: "subject-role-list"),
            input: input
        )
        #expect(result.items.map(\.id) == ["r-2"])
        #expect(await query.lastQuery?.search == "edit")

        let forbiddenExecutor = MockQueryExecutor(
            context: Role.List.Scope(role: query)
        )
        let forbiddenUseCase = Role.List.UseCase(
            authorizer: MockAuthorizer(result: false),
            query: forbiddenExecutor
        )
        await #expect(throws: AuthError.self) {
            _ = try await forbiddenUseCase.execute(
                subject: Subject(id: "subject-role-list"),
                input: input
            )
        }
        #expect(await forbiddenExecutor.runCallCount == 0)
    }

    @Test
    func editIdentitySuccessForbiddenAndNotFound() async throws {
        let repository = MockIdentityRepository(
            result: makeIdentity(id: "i-3", name: "Before"),
            findByIdResult: makeIdentity(id: "i-3", name: "Before")
        )
        let transaction = MockTransactionExecutor(
            context: Identity.Edit.Scope(
                identity: repository,
                role: MockRoleRepository(result: makeRole(id: "r-3"))
            )
        )
        let useCase = Identity.Edit.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: transaction
        )
        let result = try await useCase.execute(
            subject: Subject(id: "subject-identity-edit"),
            input: .init(id: "i-3", name: .set("After"), status: .set(.active))
        )
        #expect(result.name == "After")
        #expect(result.status == .active)
        #expect(await repository.updateCallCount == 1)

        let forbiddenTransaction = MockTransactionExecutor(
            context: Identity.Edit.Scope(
                identity: repository,
                role: MockRoleRepository(result: makeRole(id: "r-3"))
            )
        )
        let forbidden = Identity.Edit.UseCase(
            authorizer: MockAuthorizer(result: false),
            transaction: forbiddenTransaction
        )
        await #expect(throws: AuthError.self) {
            _ = try await forbidden.execute(
                subject: Subject(id: "subject-identity-edit"),
                input: .init(id: "i-3")
            )
        }
        #expect(await forbiddenTransaction.runCallCount == 0)

        let missingRepository = MockIdentityRepository(
            result: makeIdentity(id: "i-3")
        )
        let missing = Identity.Edit.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: MockTransactionExecutor(
                context: Identity.Edit.Scope(
                    identity: missingRepository,
                    role: MockRoleRepository(result: makeRole(id: "r-3"))
                )
            )
        )
        await #expect(throws: Identity.Edit.Error.self) {
            _ = try await missing.execute(
                subject: Subject(id: "subject-identity-edit"),
                input: .init(id: "missing")
            )
        }
        #expect(await missingRepository.updateCallCount == 0)
    }

    @Test
    func editRoleSuccessForbiddenAndNotFound() async throws {
        let repository = MockRoleRepository(
            result: makeRole(id: "r-5"),
            findResult: makeRole(id: "r-5")
        )
        let useCase = Role.Edit.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: MockTransactionExecutor(
                context: Role.Edit.Scope(role: repository)
            )
        )
        let result = try await useCase.execute(
            subject: Subject(id: "subject-role-edit"),
            input: .init(id: "r-5", name: .set("Editors"), notes: .clear)
        )
        #expect(result.name == "Editors")
        #expect(result.notes == nil)
        #expect(await repository.updateCallCount == 1)

        let forbiddenTransaction = MockTransactionExecutor(
            context: Role.Edit.Scope(role: repository)
        )
        let forbidden = Role.Edit.UseCase(
            authorizer: MockAuthorizer(result: false),
            transaction: forbiddenTransaction
        )
        await #expect(throws: AuthError.self) {
            _ = try await forbidden.execute(
                subject: Subject(id: "subject-role-edit"),
                input: .init(id: "r-5")
            )
        }
        #expect(await forbiddenTransaction.runCallCount == 0)

        let missingRepository = MockRoleRepository(result: makeRole(id: "r-5"))
        let missing = Role.Edit.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: MockTransactionExecutor(
                context: Role.Edit.Scope(role: missingRepository)
            )
        )
        await #expect(throws: Role.Edit.Error.self) {
            _ = try await missing.execute(
                subject: Subject(id: "subject-role-edit"),
                input: .init(id: "missing")
            )
        }
        #expect(await missingRepository.updateCallCount == 0)
    }

    @Test
    func searchIdentitiesForbidden() async throws {
        let queries = MockIdentitySearch(result: .init(items: [], total: 0))
        let queryExecutor = MockQueryExecutor(
            context: Identity.Search.Scope(identity: queries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = Identity.Search.UseCase(
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
            context: Role.Add.Scope(role: roleRepo)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Role.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: .init(
                key: "manager",
                name: "Manager",
                notes: "can manage things"
            )
        )

        #expect(result.id == "r-2")
        #expect(await roleRepo.createCallCount == 1)
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func addRoleForbidden() async throws {
        let repository = MockRoleRepository(result: makeRole(id: "r-0"))
        let transaction = MockTransactionExecutor(
            context: Role.Add.Scope(role: repository)
        )
        let useCase = Role.Add.UseCase(
            authorizer: MockAuthorizer(result: false),
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-add-role-forbidden"),
                input: .init(key: "editor", name: "Editor", notes: nil)
            )
        }
        #expect(await transaction.runCallCount == 0)
        #expect(await repository.createCallCount == 0)
    }

    @Test
    func searchRolesReturnsItemsAndTotal() async throws {
        let queries = MockRoleSearch(result: .init(items: [], total: 7))
        let queryExecutor = MockQueryExecutor(
            context: Role.Search.Scope(role: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = Role.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: .init(query: .init())
        )
        #expect(list.items.count == 0)
        #expect(list.total == 7)
        #expect(await queries.searchCallCount == 1)
    }

    @Test
    func removeRoleForbidden() async throws {
        let roleRepo = MockRoleRepository(
            result: makeRole(id: "r-4"),
            deleteResult: ["r-4"]
        )
        let transaction = MockTransactionExecutor(
            context: Role.Remove.Scope(role: roleRepo)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = Role.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-6"),
                input: .init(ids: ["r-4"])
            )
        }
        #expect(await roleRepo.deleteCallCount == 0)
    }

}

private func makeIdentity(
    id: String,
    name: String = "User",
    status: Identity.Model.Status = .invited
) -> Identity.Model {
    .init(
        id: id,
        name: name,
        status: status,
        isRoot: false,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRole(
    id: String
) -> Role.Model {
    .init(
        id: id,
        key: "role-\(id)",
        name: "Role \(id)",
        notes: "Notes \(id)",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeIdentityDetail(
    id: String
) -> Identity.Detail.Output {
    .init(
        id: id,
        name: "Identity \(id)",
        status: .invited,
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeRoleDetail(
    id: String
) -> Role.Detail.Output {
    .init(
        id: id,
        key: "role-\(id)",
        name: "Detail \(id)",
        notes: "Detail notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private actor TestIdentityDetailQuery: Identity.Detail.Query.Interface {
    private(set) var requestedID: String?
    private let result: Identity.Detail.Output

    init(result: Identity.Detail.Output) {
        self.result = result
    }

    func find(id: String) async throws -> Identity.Detail.Output {
        requestedID = id
        return result
    }
}

private actor TestRoleDetailQuery: Role.Detail.Query.Interface {
    private(set) var requestedID: String?
    private let result: Role.Detail.Output

    init(result: Role.Detail.Output) {
        self.result = result
    }

    func find(id: String) async throws -> Role.Detail.Output {
        requestedID = id
        return result
    }
}

private actor TestIdentityListQuery: Identity.List.Query.Interface {
    private(set) var lastQuery: Identity.List.Input.Query?
    private let result: Identity.List.Output

    init(result: Identity.List.Output) {
        self.result = result
    }

    func list(query: Identity.List.Input.Query) async throws
        -> Identity.List.Output
    {
        lastQuery = query
        return result
    }

}

private actor TestRoleListQuery: Role.List.Query.Interface {
    private(set) var lastQuery: Role.List.Input.Query?
    private let result: Role.List.Output

    init(result: Role.List.Output) {
        self.result = result
    }

    func list(query: Role.List.Input.Query) async throws -> Role.List.Output {
        lastQuery = query
        return result
    }

}
