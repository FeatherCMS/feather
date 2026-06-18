public protocol LogQueries: Sendable {

    func find(
        id: String
    ) async throws -> LogDetail

    func overview(
        query: LogOverview.Query
    ) async throws -> LogOverview

    func list(
        query: LogList.Query
    ) async throws -> LogList

    func count(
        query: LogList.Query
    ) async throws -> Int
}
