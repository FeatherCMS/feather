import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddMediaAssetDefaultInteractor: AdminAddMediaAssetInteractor {
    let repository: AdminAddMediaAssetOpenAPIRepository

    func getAddMediaAsset() async throws -> AdminAddMediaAssetModel {
        .init(
            parentId: "",
            fileName: "",
            extension: "bin",
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
        payload: AssetAddUpload,
        variants: [String]?
    ) async throws -> AdminAddMediaAssetModel {
        do {
            let asset = try await repository.createAsset(
                payload: payload,
                variants: variants
            )
            return .init(
                parentId: "",
                fileName: "",
                extension: "bin",
                title: "",
                altText: "",
                data: "",
                error: nil,
                view: payload.view,
                action: "/admin/media/assets/add/",
                isPicker: false,
                selectedAsset: asset
            )
        }
        catch let error as OpenAPIRepositoryError {
            let message: String
            switch error {
            case .conflict:
                message =
                    "A media asset with this name already exists in this location."
            case .failure(let failure)
                where failure.backendError?.trace?.containsDuplicatePath == true:
                message =
                    "A media asset with this name already exists in this location."
            default:
                message =
                    "Failed to create media asset: \(error.errorDescription)"
            }
            return .init(
                parentId: payload.parentId,
                fileName: payload.fileName,
                extension: payload.extension,
                title: payload.title,
                altText: payload.altText,
                data: "",
                error: message,
                view: payload.view,
                action: "/admin/media/assets/add/",
                isPicker: false,
                selectedAsset: nil
            )
        }
    }
}

private extension OpenAPIRepositoryError.BackendError.Trace {
    var containsDuplicatePath: Bool {
        if id == "MediaApplication.CreateMediaAsset.Error",
           message == "duplicatePath"
        {
            return true
        }

        return reasons?.contains(where: { $0.containsDuplicatePath }) == true
    }
}
