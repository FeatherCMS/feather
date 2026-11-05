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

extension FormField.List {
    struct Model: Sendable {
        let fields: [FormField.Model]
        let forms: [FormOption]
        let total: Int
    }
}
