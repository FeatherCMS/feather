import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Foundation
import NewsApplication
import NewsModule
import Testing

@Suite
struct CategoryListUseCaseTests {
    @Test
    func listAuthorizesAndReturnsQueryResult() async throws {
        let query = Category.List.Query.Mock(
            result: .init(
                items: [
                    .init(
                        id: "category-1",
                        title: "News",
                        excerpt: "Latest updates",
                        imageAssetId: nil,
                        createdAt: Date(timeIntervalSince1970: 1_700_000_000),
                        updatedAt: Date(timeIntervalSince1970: 1_700_000_000)
                    )
                ]
            )
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Category.List.Scope(category: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Category.List.UseCase(
            authorizer: authorizer,
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-category"),
            input: .init()
        )

        #expect(result.items.map(\.id) == ["category-1"])
        #expect(result.items.map(\.title) == ["News"])
        #expect(await authorizer.canCallCount == 1)
        #expect(await query.listCallCount == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func deniedListDoesNotExecuteQuery() async throws {
        let query = Category.List.Query.Mock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Category.List.Scope(category: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Category.List.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "admin-denied"),
                input: .init()
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.listCallCount == 0)
        #expect(await executor.runCallCount == 0)
    }
}
