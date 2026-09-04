import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminContactFieldRow: Sendable {
    let id: String
    let key: String
    let type: String
    let label: String
    let allowedValues: String
    let isRequired: Bool
    let position: String
}
