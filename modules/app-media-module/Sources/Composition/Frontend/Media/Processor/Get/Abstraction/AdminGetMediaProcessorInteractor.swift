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

protocol AdminGetMediaProcessorInteractor: Sendable {

    func getMediaProcessor(
        id: String
    ) async throws -> AdminGetMediaProcessorModel
}
