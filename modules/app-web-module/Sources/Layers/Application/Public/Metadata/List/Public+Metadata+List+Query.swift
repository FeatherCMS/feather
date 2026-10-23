extension Public.Metadata.List {
    public enum Query {}
}

extension Public.Metadata.List.Query {
    public protocol Interface: Sendable {
        func list() async throws -> Public.Metadata.List.Output
    }
}
