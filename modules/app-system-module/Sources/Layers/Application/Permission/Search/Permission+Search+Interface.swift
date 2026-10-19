public import SystemModule

extension Permission.Search {
    public protocol Interface: Sendable {
        func search(query: Input.Query) async throws -> Output
    }
}
