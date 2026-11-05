public import WebDomain
public import WebModule

extension Page.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Page.Model
        }
    }
}
