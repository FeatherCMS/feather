import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminGetContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
}
