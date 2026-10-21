import RedirectModule

extension RedirectModule.Rule.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Output
        }
    }
}
