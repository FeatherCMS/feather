import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddContactFieldInteractor: Sendable {
    func getAddContactField() async throws -> AdminAddContactFieldModel
    func postAddContactField(payload: ContactFieldFormInput)
        async throws -> AdminAddContactFieldModel
}
