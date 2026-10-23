import ContactApplication
import ContactModule
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import Testing

@testable import ContactInfrastructure
@testable import FeatherDBAL

private enum SubmissionSearchQueryKey: DatabaseQueryKey {
    case items
    case count
}

@Suite
struct SubmissionSearchQueryTests {

    @Test
    func formKeyFilterAppliesToItemsAndCountQueries() async throws {
        let connection = MockDatabaseConnection<SubmissionSearchQueryKey>(
            responses: [
                .init(key: .items),
                .init(key: .count, rows: [.init(["count": .int(0)])]),
            ]
        )
        let query = Submission.Search.Query.Database(
            context: .init(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let result = try await query.search(
            query: .init(search: nil, formKey: "contact-form")
        )
        try await connection.assertAllResponsesConsumed()

        #expect(result.items.isEmpty)
        #expect(result.total == 0)
        let executedQueries = await connection.executedQueries()
        let itemsQuery = try #require(executedQueries[.items]?.first)
        let countQuery = try #require(executedQueries[.count]?.first)

        #expect(itemsQuery.sql.contains("f.key = {{1}}"))
        #expect(countQuery.sql.contains("f.key = {{1}}"))
        #expect(itemsQuery.bindings.first?.binding == .string("contact-form"))
        #expect(countQuery.bindings.first?.binding == .string("contact-form"))
    }
}
