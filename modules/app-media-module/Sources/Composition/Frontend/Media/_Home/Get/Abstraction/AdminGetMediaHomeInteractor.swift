import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaHomeInteractor: Sendable {

    func getHome() async throws -> AdminGetMediaHomeModel
}
