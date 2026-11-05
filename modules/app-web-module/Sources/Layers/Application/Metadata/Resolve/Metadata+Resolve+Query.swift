public import WebModule

extension Metadata.Resolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolve(referenceType: String, referenceIDs: [String])
                async throws -> Output
        }
    }
}
