public import ContactModule

extension FormField.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String, formId: String?) async throws -> Output
        }
    }
}
