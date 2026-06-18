import Testing
import Domain
import Application
import struct Foundation.Date
import SystemDomain
@testable import SystemApplication

@Suite
struct SystemApplicationTestSuite {

    @Test
    func addVariableSuccess() async throws {
        let repository = VariableMockRepository(
            result: .success(makeVariable(id: "v-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WriteVariable(variable: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddVariable(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: AddVariable.Input(
                name: "var-name",
                value: "var-value",
                notes: "var-notes"
            )
        )

        #expect(result.id == "v-1")
        #expect(await authorizer.canCallCount == 1)
        #expect(await transaction.runCallCount == 1)
        #expect(await repository.createCallCount == 1)
    }

    @Test
    func addVariableForbidden() async throws {
        let repository = VariableMockRepository(
            result: .success(makeVariable(id: "v-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WriteVariable(variable: repository)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = AddVariable(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-id")
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: AddVariable.Input(
                    name: "var-name",
                    value: "var-value",
                    notes: "var-notes"
                )
            )
        }
        #expect(await transaction.runCallCount == 0)
        #expect(await repository.createCallCount == 0)
    }

    @Test
    func listVariablesAndCountSuccess() async throws {
        let listQuery = VariableList.Query(
            page: .init(size: 10, number: 2),
            sort: [.init(field: .name, direction: .asc)],
            search: "needle"
        )
        let queries = VariableMockQueries(
            findResult: makeVariableDetail(id: "v-2"),
            listResult: .init(items: []),
            countResult: 42
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadVariable(variable: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListVariables(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-2"),
            input: ListVariables.Input(query: listQuery)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-2"),
            input: ListVariables.Input(query: listQuery)
        )

        #expect(list.items.count == 0)
        #expect(count == 42)
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func removeVariableForbidden() async throws {
        let repository = VariableMockRepository(
            result: .success(makeVariable(id: "v-3")),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WriteVariable(variable: repository)
        )
        let authorizer = MockAuthorizer(result: false)
        let useCase = RemoveVariable(
            authorizer: authorizer,
            transaction: transaction
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "subject-3"),
                input: RemoveVariable.Input(id: "v-3")
            )
        }
        #expect(await repository.deleteCallCount == 0)
    }

    @Test
    func addPermissionSuccess() async throws {
        let repository = PermissionMockRepository(
            result: .success(makePermission(id: "p-1"))
        )
        let transaction = MockTransactionExecutor(
            context: WritePermission(permission: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = AddPermission(
            authorizer: authorizer,
            transaction: transaction,
            idGenerator: FixedIDGenerator(id: "generated-permission")
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-4"),
            input: AddPermission.Input(name: "perm-name", notes: "perm-notes")
        )

        #expect(result.id == "p-1")
        #expect(await repository.createCallCount == 1)
    }

    @Test
    func editPermissionSuccess() async throws {
        let repository = PermissionMockRepository(
            result: .success(makePermission(id: "p-2")),
            findResult: makePermission(id: "p-2")
        )
        let transaction = MockTransactionExecutor(
            context: WritePermission(permission: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = EditPermission(
            authorizer: authorizer,
            transaction: transaction
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-5"),
            input: EditPermission.Input(
                id: "p-2",
                name: "new-perm-name",
                notes: "new-perm-notes"
            )
        )

        #expect(result.id == "p-2")
        #expect(await repository.findCallCount == 1)
        #expect(await repository.updateCallCount == 1)
    }

    @Test
    func listPermissionsAndCountSuccess() async throws {
        let listQuery = PermissionList.Query(
            page: .init(size: 5, number: 1),
            sort: [.init(field: .name, direction: .desc)],
            search: "admin"
        )
        let queries = PermissionMockQueries(
            findResult: makePermissionDetail(id: "p-3"),
            listResult: .init(items: []),
            countResult: 9
        )
        let queryExecutor = MockQueryExecutor(
            context: ReadPermission(permission: queries)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = ListPermissions(
            authorizer: authorizer,
            query: queryExecutor
        )

        let list = try await useCase.execute(
            subject: Subject(id: "subject-6"),
            input: ListPermissions.Input(query: listQuery)
        )
        let count = try await useCase.count(
            subject: Subject(id: "subject-6"),
            input: ListPermissions.Input(query: listQuery)
        )

        #expect(list.items.count == 0)
        #expect(count == 9)
        #expect(await queryExecutor.runCallCount == 2)
        #expect(await queries.listCallCount == 1)
        #expect(await queries.countCallCount == 1)
    }

    @Test
    func removePermissionSuccess() async throws {
        let repository = PermissionMockRepository(
            result: .success(makePermission(id: "p-4")),
            deleteResult: true
        )
        let transaction = MockTransactionExecutor(
            context: WritePermission(permission: repository)
        )
        let authorizer = MockAuthorizer(result: true)
        let useCase = RemovePermission(
            authorizer: authorizer,
            transaction: transaction
        )

        let deleted = try await useCase.execute(
            subject: Subject(id: "subject-7"),
            input: RemovePermission.Input(id: "p-4")
        )

        #expect(deleted)
        #expect(await repository.deleteCallCount == 1)
        #expect(await repository.lastDeleteId == "p-4")
    }
}

private func makeVariable(
    id: String
) -> Variable {
    .init(
        id: id,
        name: "valid-name",
        value: "valid-value",
        notes: "valid-notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makePermission(
    id: String
) -> Permission {
    .init(
        id: id,
        name: "valid-name",
        notes: "valid-notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makeVariableDetail(
    id: String
) -> VariableDetail {
    .init(
        id: id,
        name: "name-\(id)",
        value: "value-\(id)",
        notes: "notes-\(id)",
        createdAt: Date(),
        updatedAt: Date()
    )
}

private func makePermissionDetail(
    id: String
) -> PermissionDetail {
    .init(
        id: id,
        name: "name-\(id)",
        notes: "notes-\(id)",
        createdAt: Date(),
        updatedAt: Date()
    )
}
