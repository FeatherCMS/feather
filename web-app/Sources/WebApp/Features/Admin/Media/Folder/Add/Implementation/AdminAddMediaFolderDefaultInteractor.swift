struct AdminAddMediaFolderDefaultInteractor: AdminAddMediaFolderInteractor {
    let repository: AdminAddMediaFolderOpenAPIRepository

    func getAddMediaFolder(
        parentId: String?,
        view: String
    ) async throws -> AdminAddMediaFolderModel {
        .init(
            parentId: parentId,
            name: "",
            view: view,
            error: nil
        )
    }

    func postAddMediaFolder(
        payload: MediaFolderAddForm
    ) async throws -> AdminAddMediaFolderModel {
        do {
            try await repository.createFolder(
                name: payload.normalizedName,
                parentId: payload.normalizedParentId
            )
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                parentId: payload.normalizedParentId,
                name: payload.name,
                view: payload.view,
                error:
                    "Failed to create media folder: \(error.errorDescription)"
            )
        }
        return .init(
            parentId: payload.normalizedParentId,
            name: "",
            view: payload.view,
            error: nil
        )
    }
}
