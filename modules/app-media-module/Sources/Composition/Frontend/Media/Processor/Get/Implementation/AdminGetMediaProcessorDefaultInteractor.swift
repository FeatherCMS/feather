import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetMediaProcessorDefaultInteractor: AdminGetMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getMediaProcessor(
        id: String
    ) async throws -> AdminGetMediaProcessorModel {
        .init(item: try await repository.getProcessor(id: id))
    }
}
