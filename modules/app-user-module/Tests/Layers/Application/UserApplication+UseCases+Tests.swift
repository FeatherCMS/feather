//
//  UserApplicationTestSuite.swift
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
struct UserApplicationTestSuite {

    @Test
    func addIdentitySuccess() async throws {
        let identityRepo = MockIdentityRepository(
            result: makeIdentity(id: "a-1")
        )
        let roleRepo = MockRoleRepository(result: makeRole(id: "r-1"))
        let events = MockEventPublisher()
        let transaction = MockTransactionExecutor(
            context: Identity.Repository.Scope(
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
    func searchIdentitiesForbidden() async throws {
        let queries = MockIdentityQueries(
            detailResult: makeIdentityDetail(id: "a-3"),
            searchResult: .init(items: [], total: 0)
        )
        let queryExecutor = MockQueryExecutor(
            context: Identity.Query.Scope(identity: queries)
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
            context: Role.Repository.Scope(role: roleRepo)
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
    func searchRolesReturnsItemsAndTotal() async throws {
        let queries = MockRoleQueries(
            detailResult: makeRoleDetail(id: "r-3"),
            searchResult: .init(items: [], total: 7)
        )
        let queryExecutor = MockQueryExecutor(
            context: Role.Query.Scope(role: queries)
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
            context: Role.Repository.Scope(role: roleRepo)
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
    status: Identity.Model.Status = .invited
) -> Identity.Model {
    .init(
        id: id,
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
