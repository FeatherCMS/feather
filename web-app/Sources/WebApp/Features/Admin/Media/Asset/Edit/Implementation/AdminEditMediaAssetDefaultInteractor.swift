struct AdminEditMediaAssetDefaultInteractor: AdminEditMediaAssetInteractor {
    let repository: AdminMediaAssetOpenAPIRepository

    func load(
        id: String
    ) async throws -> AdminEditMediaAssetModel {
        let item = try await repository.getAsset(id: id)
        return .init(
            id: item.id,
            storageKey: item.storageKey,
            type: item._type,
            status: item.status,
            sizeBytes: item.sizeBytes,
            title: item.title ?? "",
            altText: item.altText ?? "",
            error: nil
        )
    }

    func update(
        id: String,
        input: AssetEditForm
    ) async throws -> AdminEditMediaAssetModel {
        let item = try await repository.updateAsset(
            id: id,
            title: input.normalizedTitle,
            altText: input.normalizedAltText
        )
        return .init(
            id: item.id,
            storageKey: item.storageKey,
            type: item._type,
            status: item.status,
            sizeBytes: item.sizeBytes,
            title: item.title ?? "",
            altText: item.altText ?? "",
            error: nil
        )
    }
}
