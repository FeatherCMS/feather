import MediaModule

extension Asset.Folder.Edit.Repository {
    protocol Interface: Sendable {
        func getFolder(
            id: String
        ) async throws -> Asset.Folder.Edit.Model

        func updateFolder(
            id: String,
            name: String
        ) async throws -> Asset.Folder.Edit.Model
    }
}

extension Asset.Folder.Edit {
    enum Repository {}
}
