import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminRemoveContactFieldInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFieldRow
    func remove(id: String) async throws
    func bulkRemove(ids: [String]) async throws
}
