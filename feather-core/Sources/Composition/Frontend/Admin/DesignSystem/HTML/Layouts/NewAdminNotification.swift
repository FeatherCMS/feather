import CSS
import HTML
import SGML
import SVG
import WebBuilders
import WebComponents

public struct NewAdminNotification: Component {
    let notification: AdminNotification

    public init(notification: AdminNotification) {
        self.notification = notification
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-notification") {
                Position(.fixed)
                Top(0.px)
                Left(50.percent)
                Transform(.translate((-50).percent, (-80).px))
                ZIndex(.number(20))
                Display(.flex)
                AlignItems(.center)
                Gap(12.px)
                Width(560.px)
                MinWidth(360.px)
                MaxWidth(92.percent)
                BoxSizing(.borderBox)
                Padding(top: 12.px, right: 48.px, bottom: 12.px, left: 22.px)
                BorderRadius(999.px)
                Border(
                    1.px,
                    .solid,
                    CSSColorValue(CSSColor(stringLiteral: "#252525"))
                )
                TextAlign(.left)
                Background(CSSColor(stringLiteral: "#111111"))
                Color(CSSColor(stringLiteral: "#ffffff"))
                BoxShadow(
                    0.px,
                    8.px,
                    blur: 24.px,
                    spread: 0.px,
                    color: CSSColor(stringLiteral: "rgba(0, 0, 0, 0.28)")
                )
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 220ms ease-out, opacity 220ms ease-out"
                )
                Opacity(0)
            },
            Class("admin-notification__icon") {
                Display(.inlineFlex)
                FlexShrink(0)
            },
            Class("admin-notification__content") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.flexStart)
                Gap(2.px)
                MinWidth(0.px)
                TextAlign(.left)
            },
            Class("admin-notification__title") {
                FontWeight(.bold)
                FontSize(0.9.rem)
                Display(.block)
            },
            Class("admin-notification__message") {
                Color(CSSColor(stringLiteral: "#d1d5db"))
                Overflow(.hidden)
                TextOverflow(.ellipsis)
                Display(.block)
                Width(100.percent)
                LineHeight(1.35)
                FontSize(0.88.rem)
            },
            Custom(".admin-notification__icon--success") {
                Color(CSSColor(stringLiteral: "#4ade80"))
            },
            Custom(".admin-notification__icon--info") {
                Color(CSSColor(stringLiteral: "#60a5fa"))
            },
            Custom(".admin-notification__icon--warning") {
                Color(CSSColor(stringLiteral: "#fbbf24"))
            },
            Custom(".admin-notification__icon--error") {
                Color(CSSColor(stringLiteral: "#f87171"))
            },
            Class("admin-notification__close") {
                Position(.absolute)
                Right(20.px)
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                FlexShrink(0)
                Width(24.px)
                Height(24.px)
                Padding(0.px)
                Border(0.px, BorderStyle.Value.none)
                BorderRadius(999.px)
                Background(.transparent)
                Color(CSSColor(stringLiteral: "#9ca3af"))
                Cursor(.pointer)
            },
            Custom(
                ".admin-notification__close:hover, .admin-notification__close:focus-visible"
            ) {
                Background(CSSColor(stringLiteral: "#2d2d2d"))
                Color(CSSColor(stringLiteral: "#ffffff"))
                Outline(0.px, .none)
            },
            Class("admin-notification.is-visible") {
                Transform(.translate((-50).percent, 0.px))
                Opacity(1)
            },
            Class("admin-notification.is-hidden") {
                Transform(.translate((-50).percent, (-80).px))
                Opacity(0)
            },
            Custom(
                ".admin-notification__icon svg, .admin-notification__close svg"
            ) {
                Width(20.px)
                Height(20.px)
            },
        ]
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            Span {
                icon
            }
            .class("admin-notification__icon admin-notification__icon--\(notification.kind.rawValue)")
            Span {
                Span(notification.title).class("admin-notification__title")
                if !notification.message.isEmpty {
                    Span(notification.message)
                        .class("admin-notification__message")
                }
            }
            .class("admin-notification__content")
            Button {
                FeatherIcons.x()
            }
            .type(.button)
            .class("admin-notification__close")
            .ariaLabel("Dismiss notification")
            .onClick("document.cookie='admin_notification=; Max-Age=0; path=/admin';var n=this.closest('#admin-toast');if(n){n.classList.remove('is-visible');n.classList.add('is-hidden');setTimeout(function(){n.remove()},220)}")
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

    public func scripts() -> [String] {
        [
            "document.addEventListener('DOMContentLoaded',function(){requestAnimationFrame(function(){var n=document.getElementById('admin-toast');if(n){n.classList.add('is-visible');setTimeout(function(){if(n){n.classList.remove('is-visible');n.classList.add('is-hidden');setTimeout(function(){n.remove()},220)}},3000);}});});"
        ]
    }
}
