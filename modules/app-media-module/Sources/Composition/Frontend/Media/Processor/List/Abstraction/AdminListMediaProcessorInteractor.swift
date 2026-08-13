import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListMediaProcessorInteractor: Sendable {

    func listMediaProcessors(
        page: Int
    ) async throws -> AdminListMediaProcessorModel

    func bulkRemove(
        ids: [String]
    ) async throws
}
