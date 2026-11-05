public import MediaModule

extension Variant.Processor.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String, variantId: String) async throws -> Output?
        }
    }
}
