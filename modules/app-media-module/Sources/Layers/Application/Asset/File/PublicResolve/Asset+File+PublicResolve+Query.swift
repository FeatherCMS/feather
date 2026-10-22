public import MediaModule

extension Asset.File.PublicResolve {
    public enum Query {
        public protocol Interface: Sendable {
            func resolvePublic(
                ids: [String],
                variants: [String]?
            ) async throws -> Output
        }
    }
}
