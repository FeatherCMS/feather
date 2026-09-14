import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFieldsInteractor: Sendable {
    func list() async throws -> [AdminContactFieldRow]
}
