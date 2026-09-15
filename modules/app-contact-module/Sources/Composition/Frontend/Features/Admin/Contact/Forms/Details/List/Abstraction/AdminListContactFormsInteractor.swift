import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListContactFormsInteractor: Sendable {
    func list() async throws -> [AdminContactFormDetailsItem]
}
