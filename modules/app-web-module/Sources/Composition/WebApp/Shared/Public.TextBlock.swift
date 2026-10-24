import HTML
import WebBuilders
import WebComponents

extension Public {
    struct TextBlock: Component {
        let text: String

        func html(context: inout BuilderContext) -> Div {
            Div {
                text
            }
            .class("public-body")
        }
    }
}
