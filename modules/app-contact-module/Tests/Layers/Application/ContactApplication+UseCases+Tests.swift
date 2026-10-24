import ContactDomain
import ContactModule
import FeatherApplication
import FeatherModuleKit
import FeatherTesting
import Testing

import struct Foundation.Date

@testable import ContactApplication

@Suite
struct ContactApplicationUseCasesTests {
    @Test
    func formDetailMappingPreservesConfiguredValues() {
        let date = Date(timeIntervalSince1970: 1_000)
        let form = Form.Model(
            id: "form-1",
            key: "contact",
            name: "Contact",
            successMessage: "Thanks",
            failureMessage: "Try again",
            redirectUrl: "/done",
            createdAt: date,
            updatedAt: date
        )

        let detail = form.asDetail

        #expect(detail.id == "form-1")
        #expect(detail.key == "contact")
        #expect(detail.successMessage == "Thanks")
        #expect(detail.failureMessage == "Try again")
        #expect(detail.redirectUrl == "/done")
        #expect(detail.createdAt == date)
        #expect(detail.updatedAt == date)
    }

    @Test
    func searchFormsReturnsQueryResults() async throws {
        let query = Form.Search.Query.Mock(
            result: .init(
                items: [.init(id: "form-1", key: "contact", name: "Contact")],
                total: 1
            )
        )
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Form.Search.Scope(form: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: true)
        let useCase = Form.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        let output = try await useCase.execute(
            subject: Subject(id: "subject-search"),
            input: .init(query: .init(search: "contact"))
        )

        #expect(output.items.map(\.id) == ["form-1"])
        #expect(output.total == 1)
        #expect(await query.lastSearch?.search == "contact")
        #expect(await authorizer.canCallCount == 1)
        #expect(await queryExecutor.runCallCount == 1)
    }

    @Test
    func searchFormsDeniedDoesNotRunQuery() async throws {
        let query = Form.Search.Query.Mock()
        let queryExecutor = FeatherTesting.QueryExecutor.Mock(
            context: Form.Search.Scope(form: query)
        )
        let authorizer = FeatherTesting.Authorizer.Mock(result: false)
        let useCase = Form.Search.UseCase(
            authorizer: authorizer,
            query: queryExecutor
        )

        await #expect(throws: AuthError.self) {
            try await useCase.execute(
                subject: Subject(id: "subject-denied"),
                input: .init(query: .init(search: "contact"))
            )
        }

        #expect(await authorizer.canCallCount == 1)
        #expect(await query.searchCallCount == 0)
        #expect(await queryExecutor.runCallCount == 0)
    }
}
