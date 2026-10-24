import FeatherApplication
import FeatherDomain
import FeatherModuleKit
import FeatherTesting
import MediaModule
import Testing

@testable import MediaApplication

@Suite
struct VariantSearchUseCaseTests {
    @Test
    func passesSearchQueryToDedicatedQuery() async throws {
        let query = Variant.Search.Query.Mock(
            result: .init(
                items: [
                    .init(
                        id: "v-2",
                        key: "preview-large",
                        name: "Large",
                        isRequired: false,
                        isActive: true
                    )
                ],
                total: 2
            )
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Variant.Search.Scope(query: query)
        )
        let useCase = Variant.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )
        let inputQuery = Variant.Search.Input.Query(
            page: .init(size: 1, number: 2),
            search: "PREVIEW"
        )

        let result = try await useCase.execute(
            subject: Subject(id: "subject-1"),
            input: .init(query: inputQuery)
        )

        #expect(result.total == 2)
        #expect(result.items.map(\.id) == ["v-2"])
        #expect(await query.lastQuery?.page.size == 1)
        #expect(await query.lastQuery?.page.number == 2)
        #expect(await query.lastQuery?.search == "PREVIEW")
        #expect(await query.searchCallCount == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func doesNotSearchVariantsWhenForbidden() async throws {
        let query = Variant.Search.Query.Mock(
            result: .init(items: [], total: 0)
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Variant.Search.Scope(query: query)
        )
        let useCase = Variant.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-1"),
                input: .init(query: .init())
            )
        }

        #expect(await query.searchCallCount == 0)
        #expect(await executor.runCallCount == 0)
    }
}

extension Variant.Search.Query {
    actor Mock: Interface {
        private(set) var searchCallCount = 0
        private(set) var lastQuery: Variant.Search.Input.Query?
        private let result: Variant.Search.Output

        init(result: Variant.Search.Output) {
            self.result = result
        }

        func search(
            query: Variant.Search.Input.Query
        ) async throws -> Variant.Search.Output {
            searchCallCount += 1
            lastQuery = query
            return result
        }
    }
}
