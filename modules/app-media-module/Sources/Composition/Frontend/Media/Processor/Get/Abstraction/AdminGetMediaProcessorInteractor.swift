import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaProcessorInteractor: Sendable {

    func getMediaProcessor(
        id: String
    ) async throws -> AdminGetMediaProcessorModel
}
