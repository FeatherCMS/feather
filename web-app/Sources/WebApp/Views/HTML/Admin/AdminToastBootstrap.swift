import HTML
import SGML
import WebStandards

struct AdminToastBootstrap: Component, FlowContent {
    let payload: AdminToastRedirect.Payload

    func content() -> some BasicTag {
        Div {
            // empty
        }
        .id("admin-toast")
        .setAttribute(name: "hidden", value: "")
        .setAttribute(name: "data-toast-type", value: payload.type)
        .setAttribute(name: "data-toast-title", value: payload.title)
        .setAttribute(name: "data-toast-message", value: payload.message)
        .setAttribute(name: "data-toast-position", value: payload.position)
    }
}
