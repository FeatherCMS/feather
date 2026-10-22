import FeatherDBAL
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import Testing
import WebApplication
import WebDomain

@testable import WebInfrastructure

@Suite
struct PageSearchQueryTestSuite {
    private enum QueryKey: DatabaseQueryKey {
        case search
        case count
    }

    @Test
    func searchBindsUserInputAndKeepsPublicationOrdering() async throws {
        let searchText = "%' OR TRUE; --"
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(key: .search),
                .init(key: .count, rows: [.init(["count": .int(0)])]),
            ]
        )
        let query = Page.Search.Query.Database(
            context: DatabaseQueryContext(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let result = try await query.search(
            query: .init(search: searchText)
        )
        try await connection.assertAllResponsesConsumed()

        #expect(result.items.isEmpty)
        #expect(result.total == 0)

        let queries = await connection.executedQueries()
        let searchQuery = try #require(queries[.search]?.first)
        #expect(searchQuery.sql.contains("publication_date"))
        #expect(searchQuery.sql.contains("NULLS LAST"))
        #expect(searchQuery.sql.contains("ORDER BY"))
        #expect(searchQuery.sql.contains("LIMIT"))
        #expect(searchQuery.sql.contains("OFFSET"))
        #expect(!searchQuery.sql.contains(searchText))
        #expect(
            searchQuery.bindings.contains {
                $0.binding == .string(searchText)
            }
        )

        let countQuery = try #require(queries[.count]?.first)
        #expect(countQuery.sql.contains("COUNT(*)"))
        #expect(!countQuery.sql.contains(searchText))
        #expect(
            countQuery.bindings.contains {
                $0.binding == .string(searchText)
            }
        )
    }
}
