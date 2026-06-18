import FeatherDatabase
import Logging
import Testing

@testable import AnalyticsInfrastructure

@Suite
struct DatabaseLogQueriesTestSuite {

    @Test
    func overviewWhereSQLExcludesAdminPathsForWebApp() {
        let queries = DatabaseLogQueries(connection: TestDatabaseConnection())

        let result = queries.overviewWhereSQL(
            source: "web_app",
            columns: ["path", "response_code"],
            whereSQL: "response_code = 404"
        )

        #expect(result.contains("response_code = 404"))
        #expect(result.contains("path NOT LIKE '/admin/%'"))
        #expect(result.contains("path NOT LIKE '/.well-known/%'"))
        #expect(result.contains("path <> '/favicon.ico'"))
    }

    @Test
    func overviewWhereSQLLeavesOtherSourcesUnchanged() {
        let queries = DatabaseLogQueries(connection: TestDatabaseConnection())

        let result = queries.overviewWhereSQL(
            source: "backend_api",
            columns: ["path", "response_code"],
            whereSQL: "response_code = 404"
        )

        #expect(result == "response_code = 404")
    }
}

private struct TestDatabaseRow: DatabaseRow {
    func decode<T: Decodable>(
        column: String,
        as: T.Type
    ) throws(DecodingError) -> T {
        fatalError("TestDatabaseRow.decode should not be called")
    }
}

private struct TestDatabaseRowSequence: DatabaseRowSequence {
    typealias Element = TestDatabaseRow

    struct AsyncIterator: AsyncIteratorProtocol {
        mutating func next() async -> TestDatabaseRow? {
            nil
        }
    }

    func makeAsyncIterator() -> AsyncIterator {
        .init()
    }

    func collect() async throws -> [TestDatabaseRow] {
        []
    }
}

private struct TestDatabaseConnection: DatabaseConnection {
    typealias RowSequence = TestDatabaseRowSequence

    let logger = Logger(label: "DatabaseLogQueriesTestSuite")

    func run<T: Sendable>(
        query: DatabaseQuery,
        _ handler: (TestDatabaseRowSequence) async throws -> T
    ) async throws(DatabaseError) -> T {
        do {
            return try await handler(TestDatabaseRowSequence())
        }
        catch {
            throw .query(error)
        }
    }
}
