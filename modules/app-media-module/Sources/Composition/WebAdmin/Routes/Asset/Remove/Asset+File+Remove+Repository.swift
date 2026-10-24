import MediaModule

extension Asset.File.Remove.Repository {
    protocol Interface: Sendable {
        func deleteAsset(id: String) async throws
    }
}
