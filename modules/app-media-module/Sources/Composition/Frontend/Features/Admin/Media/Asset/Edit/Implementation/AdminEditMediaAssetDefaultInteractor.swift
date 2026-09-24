import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditMediaAssetDefaultInteractor: AdminEditMediaAssetInteractor {
    let repository: AdminEditMediaAssetOpenAPIRepository

    func load(
        id: String
    ) async throws -> AdminEditMediaAssetModel {
        let item = try await repository.getAsset(id: id)
        return .init(
            id: item.id,
            url: item.url,
            extension: item._extension,
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
            url: item.url,
            extension: item._extension,
            status: item.status,
            sizeBytes: item.sizeBytes,
            title: item.title ?? "",
            altText: item.altText ?? "",
            error: nil
        )
    }
}
