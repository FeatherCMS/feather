import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListContactFieldsInteractor: Sendable {
    func list() async throws -> [AdminContactFieldRow]
}
