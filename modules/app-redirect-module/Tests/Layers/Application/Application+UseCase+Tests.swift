import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import RedirectApplication
import RedirectDomain
import RedirectModule
import Testing

import struct Foundation.Date

@Suite
struct ApplicationUseCaseTests {
    @Test
    func addRuleSuccess() async throws {
        let repository = RuleMockRepository(result: .success(makeRule(id: "r-1")))
        let transaction = MockTransactionExecutor(
            context: RedirectModule.Rule.Add.Scope(repository: repository)
        )
        let useCase = RedirectModule.Rule.Add.UseCase(
            authorizer: MockAuthorizer(result: true),
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
        #expect(await repository.createCallCount == 1)
    }

    @Test
    func detailAndListUseSeparateQueries() async throws {
        let queries = makeQueries()
        let detailExecutor = MockQueryExecutor(
            context: RedirectModule.Rule.Detail.Scope(query: queries)
        )
        let detail = RedirectModule.Rule.Detail.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: detailExecutor
        )
        let detailOutput = try await detail.execute(
            subject: Subject(id: "subject-1"),
            input: .init(id: "r-2")
        )

        let listExecutor = MockQueryExecutor(
            context: RedirectModule.Rule.List.Scope(query: queries)
        )
        let list = RedirectModule.Rule.List.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: listExecutor
        )
        let listOutput = try await list.execute(
            subject: Subject(id: "subject-1"),
            input: .init()
        )

        #expect(detailOutput.id == "r-2")
        #expect(listOutput.items.count == 1)
        #expect(await queries.detailCallCount == 1)
        #expect(await queries.listCallCount == 1)
    }

    @Test
    func searchAndResolveUseSeparateQueries() async throws {
        let queries = makeQueries()
        let searchExecutor = MockQueryExecutor(
            context: RedirectModule.Rule.Search.Scope(query: queries)
        )
        let search = RedirectModule.Rule.Search.UseCase(
            authorizer: MockAuthorizer(result: true),
            query: searchExecutor
        )
        let searchOutput = try await search.execute(
            subject: Subject(id: "subject-1"),
            input: .init(query: .init(search: "old"))
        )

        let resolveExecutor = MockQueryExecutor(
            context: RedirectModule.Rule.Resolve.Scope(query: queries)
        )
        let resolve = RedirectModule.Rule.Resolve.UseCase(query: resolveExecutor)
        let resolved = try await resolve.execute(input: .init(source: "/old"))

        #expect(searchOutput.total == 1)
        #expect(resolved.destination == "/new")
        #expect(await queries.searchCallCount == 1)
        #expect(await queries.resolveCallCount == 1)
    }

    @Test
    func editAndRemoveUseOperationScopes() async throws {
        let rule = makeRule(id: "r-3")
        let repository = RuleMockRepository(
            result: .success(rule),
            findResult: rule,
            deleteResult: true
        )
        let edit = RedirectModule.Rule.Edit.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: MockTransactionExecutor(
                context: RedirectModule.Rule.Edit.Scope(repository: repository)
            )
        )
        let edited = try await edit.execute(
            subject: Subject(id: "subject-1"),
            input: .init(id: "r-3", destination: .set("/changed"))
        )

        let remove = RedirectModule.Rule.Remove.UseCase(
            authorizer: MockAuthorizer(result: true),
            transaction: MockTransactionExecutor(
                context: RedirectModule.Rule.Remove.Scope(repository: repository)
            )
        )
        let removed = try await remove.execute(
            subject: Subject(id: "subject-1"),
            input: .init(ids: ["r-3"])
        )

        #expect(edited.destination == "/destination-r-3")
        #expect(removed.ids == ["r-3"])
        #expect(await repository.updateCallCount == 1)
        #expect(await repository.deleteCallCount == 1)
    }
}

private func makeQueries() -> RuleMockQueries {
    let detail = RedirectModule.Rule.Detail.Output(
        id: "r-2",
        source: "/old",
        destination: "/new",
        statusCode: .movedPermanently,
        notes: nil,
        createdAt: Date(),
        updatedAt: Date()
    )
    let listItem = RedirectModule.Rule.List.Output.Item(
        id: "r-2",
        source: "/old",
        destination: "/new",
        statusCode: .movedPermanently
    )
    let searchItem = RedirectModule.Rule.Search.Output.Item(
        id: "r-2",
        source: "/old",
        destination: "/new",
        statusCode: .movedPermanently,
        notes: nil,
        createdAt: Date(),
        updatedAt: Date()
    )
    return RuleMockQueries(
        detailResult: detail,
        listResult: .init(items: [listItem]),
        searchResult: .init(items: [searchItem], total: 1),
        resolveResult: .init(
            source: "/old",
            destination: "/new",
            statusCode: .movedPermanently
        )
    )
}

private func makeRule(id: String) -> RedirectModule.Rule.Model {
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
