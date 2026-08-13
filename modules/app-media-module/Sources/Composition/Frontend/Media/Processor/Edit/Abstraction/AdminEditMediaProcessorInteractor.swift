import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditMediaProcessorInteractor: Sendable {

    func getEditMediaProcessor(
        id: String
    ) async throws -> AdminEditMediaProcessorModel

    func postEditMediaProcessor(
        id: String,
        payload: AddProcessorForm
    ) async throws -> AdminEditMediaProcessorModel
}
