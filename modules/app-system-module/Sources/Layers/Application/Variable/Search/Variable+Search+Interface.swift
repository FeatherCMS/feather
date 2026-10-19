public import SystemModule

extension Variable.Search {
    public protocol Interface: Sendable {
        func search(query: Input.Query) async throws -> Output
    }
}
