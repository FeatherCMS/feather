import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import RedirectApplication
import RedirectDomain
import RedirectModule
import Testing

import struct Foundation.Date

@Suite
struct RedirectApplicationUseCasesTests {
    @Test
    func protectedUseCasesRejectForbiddenSubjectsBeforeExecution() async throws
    {
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let repository = Rule.Repository.Mock(
            result: .success(makeRule(id: "r-forbidden")),
            findResult: makeRule(id: "r-forbidden"),
            deleteResult: true
        )

        let addTransaction = FeatherTesting.TransactionExecutor.Mock(
            context: Rule.Add.Scope(repository: repository)
        )
        let add = Rule.Add.UseCase(
            authorizer: authorizer,
            transaction: addTransaction
        )
        await #expect(throws: AuthError.self) {
            _ = try await add.execute(
                subject: Subject(id: "subject-forbidden"),
                input: .init(
                    source: "/old",
                    destination: "/new",
                    statusCode: .movedPermanently,
                    notes: nil
                )
            )
        }

        let detailExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.Detail.Scope(
                query: Rule.Detail.Query.Mock(
                    result: .init(
                        id: "r-2",
                        source: "/old",
                        destination: "/new",
                        statusCode: .movedPermanently,
                        notes: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                )
            )
        )
        let detail = Rule.Detail.UseCase(
            authorizer: authorizer,
            query: detailExecutor
        )
        await #expect(throws: AuthError.self) {
            _ = try await detail.execute(
                subject: Subject(id: "subject-forbidden"),
                input: .init(id: "r-forbidden")
            )
        }

        let listExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.List.Scope(
                query: Rule.List.Query.Mock(
                    result: .init(
                        items: [
                            .init(
                                id: "r-2",
                                source: "/old",
                                destination: "/new",
                                statusCode: .movedPermanently
                            )
                        ]
                    )
                )
            )
        )
        let list = Rule.List.UseCase(
            authorizer: authorizer,
            query: listExecutor
        )
        await #expect(throws: AuthError.self) {
            _ = try await list.execute(
                subject: Subject(id: "subject-forbidden"),
                input: .init()
            )
        }

        let searchExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.Search.Scope(
                query: Rule.Search.Query.Mock(
                    result: .init(
                        items: [
                            .init(
                                id: "r-2",
                                source: "/old",
                                destination: "/new",
                                statusCode: .movedPermanently,
                                notes: nil,
                                createdAt: Date(),
                                updatedAt: Date()
                            )
                        ],
                        total: 1
                    )
                )
            )
        )
        let search = Rule.Search.UseCase(
            authorizer: authorizer,
            query: searchExecutor
        )
        await #expect(throws: AuthError.self) {
            _ = try await search.execute(
                subject: Subject(id: "subject-forbidden"),
                input: .init(query: .init(search: "old"))
            )
        }

        let editTransaction = FeatherTesting.TransactionExecutor.Mock(
            context: Rule.Edit.Scope(repository: repository)
        )
        let edit = Rule.Edit.UseCase(
            authorizer: authorizer,
            transaction: editTransaction
        )
        await #expect(throws: AuthError.self) {
            _ = try await edit.execute(
                subject: Subject(id: "subject-forbidden"),
                input: .init(id: "r-forbidden", destination: .set("/new"))
            )
        }

        let removeTransaction = FeatherTesting.TransactionExecutor.Mock(
            context: Rule.Remove.Scope(repository: repository)
        )
        let remove = Rule.Remove.UseCase(
            authorizer: authorizer,
            transaction: removeTransaction
        )
        await #expect(throws: AuthError.self) {
            _ = try await remove.execute(
                subject: Subject(id: "subject-forbidden"),
                input: .init(ids: ["r-forbidden"])
            )
        }

        #expect(await authorizer.canCallCount == 6)
        #expect(await addTransaction.runCallCount == 0)
        #expect(await detailExecutor.runCallCount == 0)
        #expect(await listExecutor.runCallCount == 0)
        #expect(await searchExecutor.runCallCount == 0)
        #expect(await editTransaction.runCallCount == 0)
        #expect(await removeTransaction.runCallCount == 0)
        #expect(await repository.insertCallCount == 0)
        #expect(await repository.findCallCount == 0)
        #expect(await repository.updateCallCount == 0)
        #expect(await repository.deleteCallCount == 0)
    }

    @Test
    func addRuleSuccess() async throws {
        let repository = Rule.Repository.Mock(
            result: .success(makeRule(id: "r-1"))
        )
        let transaction = FeatherTesting.TransactionExecutor.Mock(
            context: Rule.Add.Scope(repository: repository)
        )
        let useCase = Rule.Add.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: transaction
        )

        let output = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(
                source: "/old",
                destination: "/new",
                statusCode: .movedPermanently,
                notes: nil
            )
        )
        #expect(output.id == "r-1")
        #expect(output.source == "/source-r-1")
        #expect(await repository.insertCallCount == 1)
    }

    @Test
    func detailAndListUseSeparateQueries() async throws {
        let detailQuery = Rule.Detail.Query.Mock(
            result: .init(
                id: "r-2",
                source: "/old",
                destination: "/new",
                statusCode: .movedPermanently,
                notes: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
        )
        let detailExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.Detail.Scope(query: detailQuery)
        )
        let detail = Rule.Detail.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: detailExecutor
        )
        let detailOutput = try await detail.execute(
            subject: Subject(id: "subject-1"),
            input: .init(id: "r-2")
        )

        let listQuery = Rule.List.Query.Mock(
            result: .init(
                items: [
                    .init(
                        id: "r-2",
                        source: "/old",
                        destination: "/new",
                        statusCode: .movedPermanently
                    )
                ]
            )
        )
        let listExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.List.Scope(query: listQuery)
        )
        let list = Rule.List.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: listExecutor
        )
        let listOutput = try await list.execute(
            subject: Subject(id: "subject-1"),
            input: .init()
        )

        #expect(detailOutput.id == "r-2")
        #expect(listOutput.items.count == 1)
        #expect(await detailQuery.detailCallCount == 1)
        #expect(await detailQuery.lastID == "r-2")
        #expect(await listQuery.listCallCount == 1)
    }

    @Test
    func searchAndResolveUseSeparateQueries() async throws {
        let searchQuery = Rule.Search.Query.Mock(
            result: .init(
                items: [
                    .init(
                        id: "r-2",
                        source: "/old",
                        destination: "/new",
                        statusCode: .movedPermanently,
                        notes: nil,
                        createdAt: Date(),
                        updatedAt: Date()
                    )
                ],
                total: 1
            )
        )
        let searchExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.Search.Scope(query: searchQuery)
        )
        let search = Rule.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: searchExecutor
        )
        let searchOutput = try await search.execute(
            subject: Subject(id: "subject-1"),
            input: .init(query: .init(search: "old"))
        )

        let resolveQuery = Rule.Resolve.Query.Mock(
            result: .init(
                source: "/old",
                destination: "/new",
                statusCode: .movedPermanently
            )
        )
        let resolveExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Rule.Resolve.Scope(query: resolveQuery)
        )
        let resolve = Rule.Resolve.UseCase(query: resolveExecutor)
        let resolved = try await resolve.execute(input: .init(source: "/old"))

        #expect(searchOutput.total == 1)
        #expect(resolved.destination == "/new")
        #expect(await searchQuery.searchCallCount == 1)
        #expect(await searchQuery.lastQuery?.search == "old")
        #expect(await resolveQuery.resolveCallCount == 1)
        #expect(await resolveQuery.lastSource == "/old")
    }

    @Test
    func editAndRemoveUseOperationScopes() async throws {
        let rule = makeRule(id: "r-3")
        let repository = Rule.Repository.Mock(
            result: .success(rule),
            findResult: rule,
            deleteResult: true
        )
        let edit = Rule.Edit.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: FeatherTesting.TransactionExecutor.Mock(
                context: Rule.Edit.Scope(repository: repository)
            )
        )
        let edited = try await edit.execute(
            subject: Subject(id: "subject-1"),
            input: .init(id: "r-3", destination: .set("/changed"))
        )

        let remove = Rule.Remove.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            transaction: FeatherTesting.TransactionExecutor.Mock(
                context: Rule.Remove.Scope(repository: repository)
            )
        )
        let removed = try await remove.execute(
            subject: Subject(id: "subject-1"),
            input: .init(ids: ["r-3"])
        )

        #expect(edited.destination == "/changed")
        #expect(removed.ids == ["r-3"])
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.deleteCallCount == 1)
    }
}

private func makeRule(id: String) -> Rule.Model {
    .init(
        id: id,
        source: "/source-\(id)",
        destination: "/destination-\(id)",
        statusCode: .found,
        notes: "notes",
        createdAt: Date(),
        updatedAt: Date()
    )
}
