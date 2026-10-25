public import WebDomain

extension Public.Page.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Page.Model
        }
    }
}
