public import FeatherApplication
public import SystemModule

extension Job.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(page: Search.Page) async throws -> Output
        }
    }
}
