import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminRemoveMediaProcessorDefaultInteractor:
    AdminRemoveMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel {
        .init(id: id, error: nil)
    }

    func postRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel {
        do {
            try await repository.deleteProcessor(id: id)
        }
        catch let error as OpenAPIRepositoryError {
            return .init(id: id, error: error.errorDescription)
        }
        return .init(id: id, error: nil)
    }
}
