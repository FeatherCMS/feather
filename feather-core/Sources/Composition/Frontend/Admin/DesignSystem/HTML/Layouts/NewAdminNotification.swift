import CSS
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct NewAdminNotification: Component {
    let notification: AdminNotification

    public init(notification: AdminNotification) {
        self.notification = notification
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-notification") {
                Position(.absolute)
                Top(8.px)
                Left(50.percent)
                Transform(.translateX((-50).percent))
                ZIndex(.number(20))
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                Width(.auto)
                Padding(vertical: 8.px, horizontal: 12.px)
                BorderRadius(999.px)
                Background(CSSColor(stringLiteral: "#111111"))
                Color(CSSColor(stringLiteral: "#ffffff"))
                BoxShadow(0.px, 8.px, blur: 24.px, spread: 0.px, color: CSSColor(stringLiteral: "rgba(0, 0, 0, 0.28)"))
            },
            Class("admin-notification__icon") {
                Display(.inlineFlex)
                FlexShrink(0)
            },
            Class("admin-notification__content") {
                Display(.flex)
                AlignItems(.baseline)
                Gap(6.px)
                MinWidth(0.px)
            },
            Class("admin-notification__title") {
                FontWeight(.bold)
                WhiteSpace(.nowrap)
            },
            Class("admin-notification__message") {
                Color(CSSColor(stringLiteral: "#d1d5db"))
                Overflow(.hidden)
                TextOverflow(.ellipsis)
                WhiteSpace(.nowrap)
            },
            Class("admin-notification__close") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                FlexShrink(0)
                Width(24.px)
                Height(24.px)
                Padding(0.px)
                Border(0.px, .none)
                BorderRadius(999.px)
                Background(.transparent)
                Color(CSSColor(stringLiteral: "#9ca3af"))
                Cursor(.pointer)
            },
            Custom(".admin-notification__close:hover, .admin-notification__close:focus-visible") {
                Background(CSSColor(stringLiteral: "#2d2d2d"))
                Color(CSSColor(stringLiteral: "#ffffff"))
                Outline(0.px, .none)
            },
            Custom(".admin-notification__icon svg, .admin-notification__close svg") {
                Width(16.px)
                Height(16.px)
            },
        ]
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            Span {
                icon
            }
            .class("admin-notification__icon")
            Span {
                Span(notification.title).class("admin-notification__title")
                if !notification.message.isEmpty {
                    Span(notification.message).class("admin-notification__message")
                }
            }
            .class("admin-notification__content")
            Button {
                FeatherIcons.x()
            }
            .type(.button)
            .class("admin-notification__close")
            .ariaLabel("Dismiss notification")
            .onClick("this.closest('#admin-toast').remove()")
        }
        .id("admin-toast")
        .class("admin-notification")
        .data("notification-inline", "true")
        .data("toast-type", notification.kind.rawValue)
        .data("toast-title", notification.title)
        .data("toast-message", notification.message)
        .data("toast-position", notification.position)
    }

    private var icon: SVG {
        switch notification.kind {
        case .success: return FeatherIcons.checkCircle()
        case .info: return FeatherIcons.info()
        case .warning: return FeatherIcons.alertTriangle()
        case .error: return FeatherIcons.alertCircle()
        }
    }
}
