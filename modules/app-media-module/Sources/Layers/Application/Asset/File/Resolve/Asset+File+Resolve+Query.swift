public import MediaModule

extension Asset.File.Resolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolve(
                ids: [String],
                variants: [String]?
            ) async throws -> Output
        }
    }
}
