import HTML
import WebBuilders
import WebComponents

extension PublicContent {
    struct StyleAnchor: Component {
        func html(context: inout BuilderContext) -> Div { Div {} }
    }
}
