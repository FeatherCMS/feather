import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminToastBootstrap: Leaf {
    let payload: AdminToastRedirect.Payload

    public func html() -> some BasicTag {
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
