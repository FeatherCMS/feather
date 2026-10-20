import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveMediaAssetDefaultInteractor: AdminRemoveMediaAssetInteractor {
    let repository: AdminRemoveMediaAssetOpenAPIRepository

    func remove(ids: [String]) async throws {
        for id in ids {
            try await repository.deleteAsset(id: id)
        }
    }
}
