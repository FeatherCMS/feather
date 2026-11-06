public import MediaModule

extension Variant.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output?
        }
    }
}
