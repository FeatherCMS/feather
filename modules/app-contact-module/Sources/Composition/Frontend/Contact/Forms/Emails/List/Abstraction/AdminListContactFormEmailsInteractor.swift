import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactFormEmailsInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
}
