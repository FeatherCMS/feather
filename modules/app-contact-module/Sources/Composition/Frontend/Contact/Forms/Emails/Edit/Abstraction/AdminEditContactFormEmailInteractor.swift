import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditContactFormEmailInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
    func update(id: String, email: AdminContactFormEmail) async throws
}
