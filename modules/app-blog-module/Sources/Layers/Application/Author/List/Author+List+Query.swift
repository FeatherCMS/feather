public import BlogModule

extension Author.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Output
        }
    }
}
