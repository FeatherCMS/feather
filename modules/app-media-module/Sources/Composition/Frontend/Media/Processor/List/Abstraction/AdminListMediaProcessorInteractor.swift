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

protocol AdminListMediaProcessorInteractor: Sendable {

    func listMediaProcessors(
        page: Int
    ) async throws -> AdminListMediaProcessorModel

    func remove(
        ids: [String]
    ) async throws
}
