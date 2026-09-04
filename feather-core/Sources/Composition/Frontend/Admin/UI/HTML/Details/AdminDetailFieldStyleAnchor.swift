import CSS
import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminDetailFieldStyleAnchor: Leaf {

    public init() {}

    public func selectors() -> [any Selector] {
        for selector in AdminDetailFieldStyles.selectors() {
            selector
        }
    }

    public func html() -> Div {
        Div {}.hidden()
    }
}
