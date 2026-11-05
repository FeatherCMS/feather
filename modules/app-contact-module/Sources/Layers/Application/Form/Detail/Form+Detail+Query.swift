public import ContactModule

extension Form.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(key: String) async throws -> Output
        }
    }
}
