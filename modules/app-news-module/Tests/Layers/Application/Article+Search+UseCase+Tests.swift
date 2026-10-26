import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Foundation
import NewsApplication
import NewsDomain
import NewsModule
import Testing

@Suite
struct ArticleSearchUseCaseTests {
    private func output() -> Article.Search.Output {
        .init(
            items: [
                .init(
                    id: "article-1",
                    title: "Swift release",
                    excerpt: "A release note",
                    content: "Release details",
                    imageAssetId: nil,
                    createdAt: Date(timeIntervalSince1970: 1_700_000_000),
                    updatedAt: Date(timeIntervalSince1970: 1_700_000_000)
                )
            ],
            total: 1
        )
    }

    @Test
    func searchAuthorizesAndReturnsQueryResult() async throws {
        let expected = output()
        let query = Article.Search.Query.Mock(result: expected)
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Article.Search.Scope(article: query)
        )
        let useCase = Article.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: true),
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-1"),
            input: .init(query: .init(search: "release"))
        )

        #expect(result.items.map(\.id) == ["article-1"])
        #expect(result.total == 1)
        #expect(await query.lastSearch?.search == "release")
        #expect(await query.searchCallCount == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func deniedSearchDoesNotExecuteQuery() async throws {
        let query = Article.Search.Query.Mock(result: output())
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Article.Search.Scope(article: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Article.Search.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(query: .init(search: "release"))
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.searchCallCount == 0)
        #expect(await executor.runCallCount == 0)
    }

    @Test
    func searchCategoriesAuthorizesAndReturnsQueryResult() async throws {
        let query = Category.Search.Query.Mock(
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
                ],
                total: 1
            )
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Category.Search.Scope(category: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Category.Search.UseCase(
            authorizer: authorizer,
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin-category"),
            input: .init(query: .init(search: "news"))
        )

        #expect(result.items.map(\.id) == ["category-1"])
        #expect(result.total == 1)
        #expect(await query.lastSearch?.search == "news")
        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func deniedCategorySearchDoesNotExecuteQuery() async throws {
        let query = Category.Search.Query.Mock()
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Category.Search.Scope(category: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Category.Search.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "admin-denied"),
                input: .init(query: .init(search: "news"))
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.searchCallCount == 0)
        #expect(await executor.runCallCount == 0)
    }
}
