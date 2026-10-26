public import WebModule

extension WebRoute.Resolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolve(slug: String) async throws -> Metadata.Snapshot?
        }
    }
}
