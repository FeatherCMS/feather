import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminGetContactFormInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFormDetailsItem
}
