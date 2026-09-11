import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminDetailFieldStyleAnchor: Component {

    public init() {}

    public func selectors() -> [any Selector] {
        for selector in AdminDetailFieldStyles.selectors() {
            selector
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {}.hidden()
    }
}
