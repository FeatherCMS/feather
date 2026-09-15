import HTML
import SGML
import WebBuilders
import WebComponents

@available(*, deprecated, message: "Use NewAdminNotification instead.")
public struct AdminToastBootstrap: Component {
    let payload: AdminNotificationRedirect.Payload

    public func html(context: inout BuilderContext) -> some BasicTag {
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
