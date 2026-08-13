import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveMediaAssetDefaultInteractor: AdminRemoveMediaAssetInteractor {
    let repository: AdminMediaAssetOpenAPIRepository

    func getRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel {
        .init(id: id, error: nil)
    }

    func postRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel {
        do {
            try await repository.deleteAsset(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(
                id: id,
                error: "Remove failed: \(error.errorDescription)"
            )
        }
        return .init(id: id, error: nil)
    }
}
