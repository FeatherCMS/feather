public import WebModule

extension Settings.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func get() async throws -> Settings.Detail.Output
        }
    }
}
