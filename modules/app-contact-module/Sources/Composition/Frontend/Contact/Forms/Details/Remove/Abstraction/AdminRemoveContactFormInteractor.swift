import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func bulkRemove(ids: [String]) async throws
}
