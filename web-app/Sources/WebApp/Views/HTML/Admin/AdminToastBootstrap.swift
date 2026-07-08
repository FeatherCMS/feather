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
        .hidden()
        .data("toast-type", payload.type)
        .data("toast-title", payload.title)
        .data("toast-message", payload.message)
        .data("toast-position", payload.position)
    }
}
