import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import SystemDomain
import SystemModule
import Testing

import struct Foundation.Date

@testable import SystemApplication

//
//  SystemApplication+UseCases+Tests.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

@Suite
struct SystemApplicationUseCasesTests {

    @Test
    func addVariableSuccess() async throws {
        let repository = SystemModule.Variable.Repository.Mock(
            result: .success(makeVariable(id: "v-1"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Variable.Add.Scope(variable: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Variable.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: SystemModule.Variable.Add.Input(
                key: "generated-key",
                value: "var-value",
                name: "var-name",
                notes: "var-notes"
            )
        )

        #expect(result.id == "v-1")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
        #expect(await repository.insertCallCount == 1)
    }

    @Test
    func addVariableForbidden() async throws {
        let repository = SystemModule.Variable.Repository.Mock(
            result: .success(makeVariable(id: "v-1"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Variable.Add.Scope(variable: repository)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = SystemModule.Variable.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: SystemModule.Variable.Add.Input(
                    key: "generated-key",
                    value: "var-value",
                    name: "var-name",
                    notes: "var-notes"
                )
            )
        }
        #expect(await transaction.runCallCount == 0)
        #expect(await repository.insertCallCount == 0)
    }

    @Test
    func listVariablesAndCountSuccess() async throws {
        let listQuery = SystemModule.Variable.List.Input.Query(
            page: .init(size: 10, number: 2),
            sort: [.init(field: .name, direction: .asc)],
            search: "needle"
        )
        let queries = SystemModule.Variable.List.Query.Mock(
            listResult: .init(items: []),
            countResult: 42
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: SystemModule.Variable.List.Scope(variable: queries)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Variable.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: SystemModule.Variable.List.Input(query: listQuery)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-2"),
            input: SystemModule.Variable.List.Input(query: listQuery)
        )

        #expect(list.items.count == 0)
        #expect(count == 42)
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func searchVariablesSuccess() async throws {
        let queryInput = SystemModule.Variable.Search.Input.Query(
            page: .init(size: 12, number: 3),
            search: "mail"
        )
        let queries = SystemModule.Variable.Search.Mock(
            result: .init(items: [], total: 17)
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: SystemModule.Variable.Search.Scope(variable: queries)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Variable.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: SystemModule.Variable.Search.Input(query: queryInput)
        )

        #expect(result.items.isEmpty)
        #expect(result.total == 17)
        #expect(await queries.searchCallCount == 1)
        #expect(await queries.lastQuery?.search == "mail")
        #expect(await queryExecutor.runCallCount == 1)
    }

    @Test
    func getVariableSuccess() async throws {
        let queries = SystemModule.Variable.Detail.Query.Mock(
            result: makeVariable(id: "v-detail")
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: SystemModule.Variable.Detail.Scope(variable: queries)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Variable.Detail.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-detail"),
            input: .init(id: "v-detail")
        )

        #expect(result.id == "v-detail")
        #expect(result.key == "key-v-detail")
        #expect(result.value == "valid-value")
        #expect(await queries.lastFindID == "v-detail")
        #expect(await authorizer.canCallCount == 1)
    }

    @Test
    func editVariableAppliesFieldChanges() async throws {
        let repository = SystemModule.Variable.Repository.Mock(
            result: .success(makeVariable(id: "v-edit")),
            findResult: makeVariable(id: "v-edit")
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Variable.Edit.Scope(variable: repository)
        )
        let useCase = SystemModule.Variable.Edit.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-edit"),
            input: .init(
                id: "v-edit",
                key: .set("renamed-key"),
                value: .set("updated-value"),
                name: .clear,
                notes: .set("updated-notes")
            )
        )

        #expect(result.key == "renamed-key")
        #expect(result.value == "updated-value")
        #expect(result.name == nil)
        #expect(result.notes == "updated-notes")
        #expect(await repository.lastFindId == "v-edit")
        #expect(await repository.updateCallCount == 1)
    }

    @Test
    func removeVariableForbidden() async throws {
        let repository = SystemModule.Variable.Repository.Mock(
            result: .success(makeVariable(id: "v-3"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Variable.Remove.Scope(
                variable: repository
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = SystemModule.Variable.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-3"),
                input: SystemModule.Variable.Remove.Input(ids: ["v-3"])
            )
        }
        #expect(await repository.deleteCallCount == 0)
    }

    @Test
    func removeVariableSuccess() async throws {
        let repository = SystemModule.Variable.Repository.Mock(
            result: .success(makeVariable(id: "v-remove"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Variable.Remove.Scope(variable: repository)
        )
        let useCase = SystemModule.Variable.Remove.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction
        )

        _ = try await useCase.execute(
            subject: Subject(id: "subject-remove"),
            input: .init(ids: ["v-remove"])
        )

        #expect(await repository.deleteCallCount == 1)
        #expect(await repository.lastDeleteId == "v-remove")
        #expect(await transaction.runCallCount == 1)
    }

    @Test
    func addPermissionSuccess() async throws {
        let repository = SystemModule.Permission.Repository.Mock(
            result: .success(makePermission(id: "p-1"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Permission.Add.Scope(
                permission: repository
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Permission.Add.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: SystemModule.Permission.Add.Input(
                key: "generated-permission",
                name: "perm-name",
                notes: "perm-notes"
            )
        )

        #expect(result.id == "p-1")
        #expect(await repository.insertCallCount == 1)
    }

    @Test
    func editPermissionSuccess() async throws {
        let repository = SystemModule.Permission.Repository.Mock(
            result: .success(makePermission(id: "p-2")),
            findResult: makePermission(id: "p-2")
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Permission.Edit.Scope(
                permission: repository
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Permission.Edit.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: SystemModule.Permission.Edit.Input(
                id: "p-2",
                name: .set("new-perm-name"),
                notes: .set("new-perm-notes")
            )
        )

        #expect(result.id == "p-2")
        #expect(await repository.findCallCount == 1)
        #expect(await repository.lastFindId == "p-2")
        #expect(await repository.updateCallCount == 1)
    }

    @Test
    func listPermissionsAndCountSuccess() async throws {
        let listQuery = SystemModule.Permission.List.Input.Query(
            page: .init(size: 5, number: 1),
            sort: [.init(field: .name, direction: .desc)],
            search: "admin"
        )
        let queries = SystemModule.Permission.List.Query.Mock(
            listResult: .init(items: []),
            countResult: 9
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: SystemModule.Permission.List.Scope(
                permission: queries
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Permission.List.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-6"),
            input: SystemModule.Permission.List.Input(query: listQuery)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-6"),
            input: SystemModule.Permission.List.Input(query: listQuery)
        )

        #expect(list.items.count == 0)
        #expect(count == 9)
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func searchPermissionsSuccess() async throws {
        let queryInput = SystemModule.Permission.Search.Input.Query(
            page: .init(size: 8, number: 2),
            search: "admin"
        )
        let queries = SystemModule.Permission.Search.Mock(
            result: .init(items: [], total: 11)
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: SystemModule.Permission.Search.Scope(permission: queries)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Permission.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-6"),
            input: SystemModule.Permission.Search.Input(query: queryInput)
        )

        #expect(result.items.isEmpty)
        #expect(result.total == 11)
        #expect(await queries.searchCallCount == 1)
        #expect(await queries.lastQuery?.search == "admin")
        #expect(await queryExecutor.runCallCount == 1)
    }

    @Test
    func getPermissionSuccess() async throws {
        let queries = SystemModule.Permission.Detail.Query.Mock(
            result: makePermissionDetail(id: "p-detail")
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: SystemModule.Permission.Detail.Scope(
                permission: queries
            )
        )
        let useCase = SystemModule.Permission.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: queryExecutor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-detail"),
            input: .init(id: "p-detail")
        )

        #expect(result.id == "p-detail")
        #expect(result.key == "key-p-detail")
        #expect(await queries.lastFindID == "p-detail")
    }

    @Test
    func removePermissionSuccess() async throws {
        let repository = SystemModule.Permission.Repository.Mock(
            result: .success(makePermission(id: "p-4"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: SystemModule.Permission.Remove.Scope(
                permission: repository
            )
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = SystemModule.Permission.Remove.UseCase(
            authorizer: authorizer,
            transaction: transaction
        )

        _ = try await useCase.execute(
            subject: Subject(id: "subject-7"),
            input: SystemModule.Permission.Remove.Input(ids: ["p-4"])
        )

        #expect(await repository.deleteCallCount == 1)
        #expect(await repository.lastDeleteId == "p-4")
    }
}

private func makeVariable(
    id: String
) -> SystemModule.Variable.Model {
    .init(
        id: id,
        key: "key-\(id)",
        value: "valid-value",
        name: "valid-name",
        notes: "valid-notes"
    )
}

private func makePermission(
    id: String
) -> SystemModule.Permission.Model {
    .init(
        id: id,
        key: "key-\(id)",
        name: "valid-name",
        notes: "valid-notes"
    )
}

private func makePermissionDetail(
    id: String
) -> SystemModule.Permission.Detail.Output {
    .init(
        id: id,
        key: "key-\(id)",
        name: "name-\(id)",
        notes: "notes-\(id)"
    )
}
