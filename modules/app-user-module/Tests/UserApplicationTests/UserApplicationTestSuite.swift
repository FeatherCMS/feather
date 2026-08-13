//
//  UserApplicationTestSuite.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import Testing
import UserDomain

import struct Foundation.Date

@testable import UserApplication

@Suite
struct UserApplicationTestSuite {

    @Test
    func addIdentitySuccess() async throws {
        let identityRepo = MockIdentityRepository(
            result: makeIdentity(id: "a-1")
        )
        let events = MockEventPublisher()
        let transaction = MockTransactionExecutor(
            context: WriteIdentity(
                identity: identityRepo
            )
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddIdentity(
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
    func listIdentitiesForbidden() async throws {
        let queries = MockIdentityQueries(
            detailResult: makeIdentityDetail(id: "a-3"),
            listResult: .init(items: []),
            countResult: 0
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadIdentity(identity: queries)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = ListIdentities(
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
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: .init(
                id: "manager",
                name: "Manager",
                notes: "can manage things"
            )
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

}

private func makeIdentity(
    id: String,
    status: Identity.Status = .invited
) -> Identity {
    .init(
        id: id,
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

private func makeIdentityDetail(
    id: String
) -> IdentityDetail {
    .init(
        id: id,
        status: .invited,
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
