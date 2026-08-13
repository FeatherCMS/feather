import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddContactFormEmailInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func add(id: String, email: AdminContactFormEmail) async throws
}
