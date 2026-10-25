import MediaModule

extension Asset.File.Edit.Repository {
    protocol Interface: Sendable {
        func getAsset(
            id: String
        ) async throws -> Asset.File.Edit.Model

        func updateAsset(
            id: String,
            title: String?,
            altText: String?
        ) async throws -> Asset.File.Edit.Model
    }
}

extension Asset.File.Edit {
    enum Repository {}
}
