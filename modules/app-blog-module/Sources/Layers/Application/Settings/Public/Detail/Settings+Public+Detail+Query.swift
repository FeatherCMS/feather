public import BlogModule

extension BlogModule.Settings.Public.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func get() async throws -> Output
        }
    }
}
