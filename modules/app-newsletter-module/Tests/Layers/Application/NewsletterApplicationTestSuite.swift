import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import NewsletterModule
import Testing

@testable import NewsletterApplication

@Suite
struct NewsletterApplicationTestSuite {

    @Test
    func inputsAreSendableDTOs() {
        #expect(
            Campaign.Add.Input(key: "updates", name: "Updates").name
                == "Updates"
        )
        #expect(
            Issue.Add
                .Input(
                    campaignKey: "newsletter-1",
                    subject: "Subject",
                    content: "Content"
                )
                .content == "Content"
        )
        #expect(
            Subscriber.Subscribe
                .Input(
                    campaignKey: "newsletter-1",
                    email: "person@example.com"
                )
                .email == "person@example.com"
        )
    }

    @Test
    func searchSubscribersRequiresPermissionAndPassesQuery() async throws {
        let query = Subscriber.Search.Query.Mock(
            result: .init(items: [], total: 17)
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Subscriber.Search.Scope(subscriber: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Subscriber.Search.UseCase(
            authorizer: authorizer,
            query: executor
        )
        let input = Subscriber.Search.Input(
            query: .init(
                page: .init(size: 25, number: 3),
                search: "example",
                campaignKey: "weekly"
            )
        )

        let output = try await useCase.execute(
            subject: Subject(id: "admin"),
            input: input
        )

        #expect(output.total == 17)
        #expect(await authorizer.canCallCount == 1)
        #expect(await executor.runCallCount == 1)
        #expect(await query.lastQuery?.search == "example")
        #expect(await query.lastQuery?.campaignKey == "weekly")
    }

    @Test
    func searchSubscribersDoesNotQueryWhenForbidden() async {
        let query = Subscriber.Search.Query.Mock(
            result: .init(items: [], total: 0)
        )
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Subscriber.Search.Scope(subscriber: query)
        )
        let useCase = Subscriber.Search.UseCase(
            authorizer: FeatherTesting.Authorizer.Mock(result: false),
            query: executor
        )

        await #expect(throws: AuthError.self) {
            _ = try await useCase.execute(
                subject: Subject(id: "guest"),
                input: .init(query: .init())
            )
        }

        #expect(await executor.runCallCount == 0)
        #expect(await query.searchCallCount == 0)
    }
}
