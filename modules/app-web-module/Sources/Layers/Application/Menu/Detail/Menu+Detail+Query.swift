public import WebDomain

extension Menu.Detail.Query {
    public protocol Interface: Sendable {
        func find(id: String) async throws -> Menu.Detail.Output
        func find(key: String) async throws -> Menu.Detail.Output?
    }
}
