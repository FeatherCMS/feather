import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminContactFieldsList: Sendable {
    let fields: [AdminContactFieldRow]
    let forms: [FormField.List.FormOption]
}
