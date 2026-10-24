import FeatherModuleKit
import FeatherTesting
import Foundation
import NewsApplication
import NewsDomain
import NewsModule
import Testing

@Suite
struct ArticleSearchUseCaseTests {
    private struct SearchQuery: Article.Search.Query.Interface {
        let output: Article.Search.Output

        func search(query: Article.Search.Input.Query) async throws
            -> Article.Search.Output
        {
            output
        }
    }

    private func scope(
        output: Article.Search.Output
    ) -> Article.Search.Scope {
        .init(article: SearchQuery(output: output))
    }

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
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: scope(output: expected)
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
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func deniedSearchDoesNotExecuteQuery() async throws {
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: scope(output: output())
        )
        let useCase = Article.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "admin-1"),
                input: .init(query: .init(search: "release"))
            )
        }

        #expect(await executor.runCallCount == 0)
    }
}
