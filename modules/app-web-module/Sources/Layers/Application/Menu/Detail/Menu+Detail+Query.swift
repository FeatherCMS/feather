public import WebModule

extension Menu.Detail.Query {
    public protocol Interface: Sendable {
        func find(id: String) async throws -> Menu.Detail.Output
    }
}
