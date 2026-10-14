import FeatherAdmin
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

    func postRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel {
        do {
            try await repository.deleteAsset(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                item: .init(id: id, label: id),
                error: "Remove failed: \(error.errorDescription)"
            )
        }
        return .init(item: .init(id: id, label: id), error: nil)
    }
}
