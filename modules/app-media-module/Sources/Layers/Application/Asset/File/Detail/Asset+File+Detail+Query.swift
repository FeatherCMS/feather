public import MediaModule

extension Asset.File.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
