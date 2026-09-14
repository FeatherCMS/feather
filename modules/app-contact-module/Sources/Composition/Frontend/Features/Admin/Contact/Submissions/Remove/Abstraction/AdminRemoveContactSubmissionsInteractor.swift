import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactSubmissionsInteractor: Sendable {
    func remove(ids: [String]) async throws
}
