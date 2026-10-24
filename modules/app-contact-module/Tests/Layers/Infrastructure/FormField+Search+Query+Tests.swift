import ContactApplication
import ContactModule
import FeatherApplication
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import Testing

@testable import ContactInfrastructure
@testable import FeatherDBAL

private enum FormFieldSearchQueryKey: DatabaseQueryKey {
    case items
    case count
}

@Suite
struct FormFieldSearchQueryTests {

    @Test
    func searchFiltersItemsAndCountAndAppliesSortAndPage() async throws {
        let connection = MockDatabaseConnection<FormFieldSearchQueryKey>(
            responses: [
                .init(key: .items),
                .init(key: .count, rows: [.init(["count": .int(0)])]),
            ]
        )
        let query = FormField.Search.Query.Database(
            context: .init(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let result = try await query.search(
            query: .init(
                page: .init(size: 10, number: 3),
                sort: [.init(field: .label, direction: .desc)],
                search: "promo_%",
                formKey: "contact-form"
            )
        )
        try await connection.assertAllResponsesConsumed()

        #expect(result.items.isEmpty)
        #expect(result.total == 0)
        let executedQueries = await connection.executedQueries()
        let itemsQuery = try #require(executedQueries[.items]?.first)
        let countQuery = try #require(executedQueries[.count]?.first)

        #expect(
            itemsQuery.sql.contains("ORDER BY field.label DESC, field.id ASC")
        )
        #expect(itemsQuery.sql.contains("LIMIT {{4}} OFFSET {{5}}"))
        #expect(itemsQuery.sql.contains("form.key ={{3}}"))
        #expect(countQuery.sql.contains("form.key ={{3}}"))
        #expect(itemsQuery.bindings[0].binding == .string("%promo!_!%%"))
        #expect(itemsQuery.bindings[1].binding == .string("%promo!_!%%"))
        #expect(itemsQuery.bindings[2].binding == .string("contact-form"))
        #expect(countQuery.bindings[0].binding == .string("%promo!_!%%"))
        #expect(countQuery.bindings[1].binding == .string("%promo!_!%%"))
        #expect(countQuery.bindings[2].binding == .string("contact-form"))
    }

    @Test
    func unassignedFilterAppliesToItemsAndCount() async throws {
        let connection = MockDatabaseConnection<FormFieldSearchQueryKey>(
            responses: [
                .init(key: .items),
                .init(key: .count, rows: [.init(["count": .int(0)])]),
            ]
        )
        let query = FormField.Search.Query.Database(
            context: .init(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        _ = try await query.search(
            query: .init(isUnassigned: true)
        )
        try await connection.assertAllResponsesConsumed()

        let executedQueries = await connection.executedQueries()
        let itemsQuery = try #require(executedQueries[.items]?.first)
        let countQuery = try #require(executedQueries[.count]?.first)
        #expect(itemsQuery.sql.contains("NOT EXISTS"))
        #expect(countQuery.sql.contains("NOT EXISTS"))
        #expect(itemsQuery.bindings.map(\.binding) == [.int(20), .int(0)])
        #expect(countQuery.bindings.isEmpty)
    }
}
