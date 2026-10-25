public import AccountModule


extension Profile.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(userId: String) async throws -> Output
        }
    }
}
