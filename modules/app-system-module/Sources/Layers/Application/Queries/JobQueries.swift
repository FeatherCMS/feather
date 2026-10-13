public protocol JobQueries: Sendable {
    func list() async throws -> [JobDetail]
    func find(id: String) async throws -> JobDetail
}
