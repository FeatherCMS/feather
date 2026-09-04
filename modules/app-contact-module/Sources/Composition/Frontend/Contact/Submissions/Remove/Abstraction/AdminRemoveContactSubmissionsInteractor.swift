import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveContactSubmissionsInteractor: Sendable {
    func remove(ids: [String]) async throws
}
