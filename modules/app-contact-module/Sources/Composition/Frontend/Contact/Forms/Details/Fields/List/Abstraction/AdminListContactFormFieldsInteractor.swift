import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListContactFormFieldsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormFieldRow]
}
