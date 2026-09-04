import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminEditContactFieldInteractor: Sendable {
    func get(id: String) async throws -> AdminContactFieldRow
    func update(id: String, form: ContactFieldFormInput)
        async throws
}
