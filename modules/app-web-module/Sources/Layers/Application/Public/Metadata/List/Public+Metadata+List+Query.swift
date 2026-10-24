extension Public.Metadata.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Public.Metadata.List.Output
        }
    }
}
