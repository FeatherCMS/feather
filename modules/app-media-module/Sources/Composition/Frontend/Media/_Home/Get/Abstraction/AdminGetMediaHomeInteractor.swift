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

protocol AdminGetMediaHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetMediaHomeModel
}
