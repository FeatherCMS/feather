import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewContactFormInteractor: Sendable {
    func get(key: String) async throws -> AdminContactFormDetailsItem
}
