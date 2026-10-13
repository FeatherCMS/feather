import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveContactFormInteractor: Sendable {
    func get(key: String) async throws -> AdminContactFormDetailsItem
    func remove(keys: [String]) async throws
}
