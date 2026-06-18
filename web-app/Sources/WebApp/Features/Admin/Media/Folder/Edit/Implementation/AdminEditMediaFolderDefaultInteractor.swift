struct AdminEditMediaFolderDefaultInteractor: AdminEditMediaFolderInteractor {
    let repository: AdminEditMediaFolderOpenAPIRepository

    func load(
        id: String
    ) async throws -> AdminEditMediaFolderModel {
        let folder = try await repository.getFolder(id: id)
        return .init(
            id: folder.id,
            parentId: folder.parentId,
            name: folder.name,
            path: folder.path,
            assetCount: folder.assetCount,
            totalSizeBytes: folder.totalSizeBytes,
            error: nil
        )
    }

    func update(
        id: String,
        input: MediaFolderEditForm
    ) async throws -> AdminEditMediaFolderModel {
        let folder = try await repository.updateFolder(
            id: id,
            name: input.normalizedName
        )
        return .init(
            id: folder.id,
            parentId: folder.parentId,
            name: folder.name,
            path: folder.path,
            assetCount: folder.assetCount,
            totalSizeBytes: folder.totalSizeBytes,
            error: nil
        )
    }
}
