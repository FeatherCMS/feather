import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AppPublicTextBlock: Component {
    let text: String

    func html(context: inout RenderContext) -> Div {
        Div {
            text
        }
        .class("public-body")
    }
}
