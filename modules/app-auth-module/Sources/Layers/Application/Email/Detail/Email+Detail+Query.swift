public import AuthModule

extension Email.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
