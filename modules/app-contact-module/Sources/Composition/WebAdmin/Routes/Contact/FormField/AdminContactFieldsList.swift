import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminContactFieldsList: Sendable {
    let fields: [AdminContactFieldRow]
    let forms: [AdminContactFormFilterOption]
}

struct AdminContactFormFilterOption: Sendable {
    let key: String
    let name: String
}
