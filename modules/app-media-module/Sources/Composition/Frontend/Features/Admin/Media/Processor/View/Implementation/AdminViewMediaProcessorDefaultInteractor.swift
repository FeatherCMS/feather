import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewMediaProcessorDefaultInteractor:
    AdminViewMediaProcessorInteractor
{
    let repository: AdminMediaProcessorOpenAPIRepository

    func getMediaProcessor(
        id: String
    ) async throws -> AdminViewMediaProcessorModel {
        .init(item: try await repository.getProcessor(id: id))
    }
}
