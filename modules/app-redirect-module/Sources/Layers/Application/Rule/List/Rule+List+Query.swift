public import RedirectModule

extension Rule.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Output
        }
    }
}
