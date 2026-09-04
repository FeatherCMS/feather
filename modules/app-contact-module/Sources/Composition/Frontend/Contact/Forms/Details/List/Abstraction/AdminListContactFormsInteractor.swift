import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListContactFormsInteractor: Sendable {
    func list() async throws -> [AdminContactFormDetailsItem]
}
