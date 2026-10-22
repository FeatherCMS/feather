import HTML
import Builders
import Components

struct AppPublicTextBlock: Component {
    let text: String

    func html(context: inout BuilderContext) -> Div {
        Div {
            text
        }
        .class("public-body")
    }
}
