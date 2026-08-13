import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaProcessorInteractor: Sendable {

    func getAddMediaProcessor() async throws
        -> AdminAddMediaProcessorModel

    func postAddMediaProcessor(
        payload: AddProcessorForm
    ) async throws -> AdminAddMediaProcessorModel
}
