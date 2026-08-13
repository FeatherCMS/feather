import CSS
import HTML
import SGML
import WebStandards

public struct AdminDetailFieldStyleAnchor: Component, FlowContent {

    public init() {}

    public func selectors() -> [any Selector] {
        for selector in AdminDetailFieldStyles.selectors() {
            selector
        }
    }

    public func content() -> some BasicTag {
        Div {}.hidden()
    }
}
