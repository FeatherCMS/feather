import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension ContactModule.FormField {
    struct Option: Codable, Sendable, Equatable, Hashable {
        let id: String
        let key: String
        let label: String
    }
}
