import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AppPublicTextBlock: Component {
    let text: String

    func html(context: inout RenderContext) -> Div {
        Div {
            text
        }
        .class("public-body")
    }
}
