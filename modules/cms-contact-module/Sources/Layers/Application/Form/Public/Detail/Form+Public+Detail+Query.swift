public import ContactModule

extension Form.Public.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(key: String) async throws -> Output
        }
    }
}
