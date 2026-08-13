import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactFieldModel: Sendable {
    let key: String
    let type: String
    let label: String
    let allowedValues: String
    let isRequired: Bool
    let position: String
    let error: String?
}
