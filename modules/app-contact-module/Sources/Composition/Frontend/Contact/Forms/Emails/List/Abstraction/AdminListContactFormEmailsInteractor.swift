import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListContactFormEmailsInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
}
