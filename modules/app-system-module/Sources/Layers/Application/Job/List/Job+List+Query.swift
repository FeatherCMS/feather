public import SystemModule
public import FeatherApplication

extension Job.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(page: Search.Page) async throws -> Output
        }
    }
}
