import MediaModule

extension Asset.Folder.Add.Repository {
    protocol Interface: Sendable {
        func createFolder(
            name: String,
            parentId: String?
        ) async throws
    }
}
