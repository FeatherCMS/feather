public import BlogModule

extension BlogModule.Settings.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func get() async throws -> Output
        }
    }
}
