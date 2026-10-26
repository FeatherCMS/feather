public import ContactModule

extension Submission.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(formKey: String, id: String) async throws -> Output
        }
    }
}
