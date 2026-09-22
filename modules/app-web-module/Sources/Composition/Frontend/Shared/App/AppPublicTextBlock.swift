import FeatherAdmin
import HTML
import WebComponents
import WebBuilders

struct AppPublicTextBlock: Component {
    let text: String

    func html(context: inout BuilderContext) -> Div {
        Div {
            text
        }
        .class("public-body")
    }
}
