import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactSubmissionsInteractor: Sendable {
    func bulkRemove(ids: [String]) async throws
}
