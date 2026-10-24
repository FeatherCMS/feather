public import AnalyticsModule

extension Log.Overview {
    public enum Query {
        public protocol Interface: Sendable {
            func overview(query: Input.Query) async throws -> Output
        }
    }
}
