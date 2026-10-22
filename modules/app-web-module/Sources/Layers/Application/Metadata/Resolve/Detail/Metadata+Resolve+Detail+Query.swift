public import WebModule

extension Metadata.Resolve.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func resolveDetails(referenceType: String, referenceIDs: [String])
                async throws -> [Metadata.Detail.Output]
        }
    }
}
