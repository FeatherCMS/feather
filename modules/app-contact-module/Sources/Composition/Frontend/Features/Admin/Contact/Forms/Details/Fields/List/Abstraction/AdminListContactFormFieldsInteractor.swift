import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormFieldsInteractor: Sendable {
    func list(formId: String) async throws -> [AdminContactFormFieldRow]
}
