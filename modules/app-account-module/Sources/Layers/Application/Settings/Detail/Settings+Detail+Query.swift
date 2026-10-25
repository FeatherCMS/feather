public import AccountModule


extension Settings.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(userId: String) async throws -> Output
        }
    }
}
