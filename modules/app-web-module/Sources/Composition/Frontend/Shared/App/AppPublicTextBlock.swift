import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AppPublicTextBlock: Leaf {
    let text: String

    func html() -> Div {
        Div {
            text
        }
        .class("public-body")
    }
}
