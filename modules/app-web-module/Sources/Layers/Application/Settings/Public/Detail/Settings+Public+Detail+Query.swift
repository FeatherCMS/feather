public import WebModule

extension Settings.Public.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func get() async throws -> Output
        }
    }
}
