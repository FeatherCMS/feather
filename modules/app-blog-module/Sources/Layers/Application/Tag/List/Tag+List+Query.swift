public import BlogModule

extension Tag.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Output
        }
    }
}
