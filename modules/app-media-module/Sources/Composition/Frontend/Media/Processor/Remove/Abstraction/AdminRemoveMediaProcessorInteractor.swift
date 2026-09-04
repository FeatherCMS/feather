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

protocol AdminRemoveMediaProcessorInteractor: Sendable {

    func getRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel

    func postRemoveMediaProcessor(
        id: String
    ) async throws -> AdminRemoveMediaProcessorModel
}
