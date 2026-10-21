import RedirectModule

extension RedirectModule.Rule.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func detail(id: String) async throws -> Output
        }
    }
}
