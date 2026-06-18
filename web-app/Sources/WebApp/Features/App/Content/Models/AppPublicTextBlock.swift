import HTML
import SGML
import WebStandards

struct AppPublicTextBlock: Component, FlowContent {
    let text: String

    func content() -> some BasicTag {
        Div {
            text
        }
        .class("public-body")
    }
}
