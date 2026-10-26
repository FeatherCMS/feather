import ContactModule
import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Testing

@Suite
struct FormListUseCaseTests {
    @Test
    func listFormsAuthorizesAndReturnsQueryResult() async throws {
        let query = Form.List.Query.Mock(result: .init(items: []))
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Form.List.Scope(form: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Form.List.UseCase(
            authorizer: authorizer,
            query: executor
        )

        let result = try await useCase.execute(
            subject: Subject(id: "admin"),
            input: .init()
        )

        #expect(result.items.isEmpty)
        #expect(await authorizer.canCallCount == 1)
        #expect(await query.listCallCount == 1)
        #expect(await executor.runCallCount == 1)
    }

    @Test
    func deniedListDoesNotExecuteQuery() async throws {
        let query = Form.List.Query.Mock(result: .init(items: []))
        let executor = FeatherTesting.QueryExecutor.Mock(
            context: Form.List.Scope(form: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Form.List.UseCase(
            authorizer: authorizer,
            query: executor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "guest"),
                input: .init()
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.listCallCount == 0)
        #expect(await executor.runCallCount == 0)
    }
}
