public import ContactModule

extension FormField.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(input: Input) async throws -> Output
        }
    }
}
