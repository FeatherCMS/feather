import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFieldsInteractor: Sendable {
    func list(formKey: String?) async throws -> AdminContactFieldsList
}
