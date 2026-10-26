public import WebModule

extension Metadata.Reference {
    public enum Query {
        public protocol Interface: Sendable {
            func find(referenceType: String, referenceID: String) async throws
                -> Metadata.Snapshot?
        }
    }
}
