public import RedirectModule

extension RedirectModule.Rule.Resolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolve(source: String) async throws -> Output?
        }
    }
}
