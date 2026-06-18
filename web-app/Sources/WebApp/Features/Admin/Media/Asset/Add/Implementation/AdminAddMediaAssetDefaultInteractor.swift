import Hummingbird

struct AdminAddMediaAssetDefaultInteractor: AdminAddMediaAssetInteractor {
    let repository: AdminMediaAssetOpenAPIRepository

    func getAddMediaAsset() async throws -> AdminAddMediaAssetModel {
        .init(
            parentId: "",
            fileName: "",
            type: "bin",
            title: "",
            altText: "",
            data: "",
            error: nil,
            view: "grid",
            action: "/admin/media/assets/add/",
            isPicker: false,
            selectedAsset: nil
        )
    }

    func postAddMediaAsset(
        payload: AssetAddForm
    ) async throws -> AdminAddMediaAssetModel {
        do {
            let asset = try await repository.createAsset(payload: payload)
            return .init(
                parentId: "",
                fileName: "",
                type: "bin",
                title: "",
                altText: "",
                data: "",
                error: nil,
                view: payload.view,
                action: "/admin/media/assets/add/",
                isPicker: false,
                selectedAsset: AdminMediaAssetReferenceModel(schema: asset)
            )
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                parentId: payload.parentId,
                fileName: payload.fileName,
                type: payload.type,
                title: payload.title,
                altText: payload.altText,
                data: payload.data,
                error:
                    "Failed to create media asset: \(error.errorDescription)",
                view: payload.view,
                action: "/admin/media/assets/add/",
                isPicker: false,
                selectedAsset: nil
            )
        }
    }
}
