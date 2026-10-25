public import CSS
import Foundation
public import HTML
public import Hummingbird
import SGML
import SVG
import WebBuilders
public import WebComponents

public struct AdminNotification: Component {
    public static let cookieName = "admin_notification"

    public struct State: Codable, Sendable, Equatable {
        public enum Kind: String, Codable, Sendable {
            case success
            case info
            case warning
            case error
        }

        public let kind: Kind
        public let title: String
        public let message: String
        public let position: String

        public init(
            kind: Kind = .success,
            title: String,
            message: String,
            position: String = "top-right"
        ) {
            self.kind = kind
            self.title = title
            self.message = message
            self.position = position
        }
    }

    let state: State

    public init(notification: State) {
        self.state = notification
    }

    public static func state(from request: Request) -> State? {
        guard
            let value = request.cookies[cookieName]?.value,
            let data = Data(base64Encoded: value)
        else { return nil }
        return try? JSONDecoder().decode(State.self, from: data)
    }

    public static func cookie(for notification: State) -> Cookie {
        let data = (try? JSONEncoder().encode(notification)) ?? Data()
        return Cookie(
            name: cookieName,
            value: data.base64EncodedString(),
            maxAge: 30,
            path: "/admin",
            httpOnly: false,
            sameSite: .lax
        )
    }

    public static func clearCookie() -> Cookie {
        Cookie(
            name: cookieName,
            value: "",
            maxAge: 0,
            path: "/admin",
            httpOnly: false,
            sameSite: .lax
        )
    }

    public static func redirect(
        to location: String,
        notification: State
    ) -> Response {
        var headers: HTTPFields = [.location: location]
        headers[values: .setCookie]
            .append(cookie(for: notification).description)
        return Response(status: .seeOther, headers: headers)
    }

    public static func styleSelectors() -> [any CSS.Selector] {
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
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                TextAlign(.left)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
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
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
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
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom(
                ".admin-notification__close:hover, .admin-notification__close:focus-visible"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
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

    public func selectors() -> [any CSS.Selector] {
        Self.styleSelectors()
    }

    public static func showScript(_ notification: State) -> String {
        "window.adminNotification.show({kind:\(javascriptString(notification.kind.rawValue)),title:\(javascriptString(notification.title)),message:\(javascriptString(notification.message)),position:\(javascriptString(notification.position))})"
    }

    public static let clientRuntimeScript = #"""
        (function () {
            if (window.adminNotification) {
                return;
            }

            function dismiss(notification) {
                if (!notification.isConnected) {
                    return;
                }
                notification.classList.remove("is-visible");
                notification.classList.add("is-hidden");
                setTimeout(function () {
                    notification.remove();
                }, 220);
            }

            function present(notification) {
                requestAnimationFrame(function () {
                    requestAnimationFrame(function () {
                        notification.classList.add("is-visible");
                    });
                });
                setTimeout(function () {
                    dismiss(notification);
                }, 3000);
            }

            window.adminNotification = {
                show: function (state) {
                    var previous = document.getElementById("admin-toast");
                    if (previous) {
                        previous.remove();
                    }

                    var kind = ["success", "info", "warning", "error"]
                        .includes(state.kind) ? state.kind : "info";
                    var notification = document.createElement("div");
                    notification.id = "admin-toast";
                    notification.className = "admin-notification";
                    notification.setAttribute("role", "status");
                    notification.dataset.notificationInline = "true";
                    notification.dataset.toastType = kind;
                    notification.dataset.toastTitle = state.title;
                    notification.dataset.toastMessage = state.message;
                    notification.dataset.toastPosition = state.position || "top-right";

                    var icon = document.createElement("span");
                    icon.className = "admin-notification__icon admin-notification__icon--" + kind;
                    icon.textContent = kind === "success" ? "✓" : kind === "warning" ? "!" : kind === "error" ? "×" : "i";

                    var content = document.createElement("span");
                    content.className = "admin-notification__content";
                    var title = document.createElement("span");
                    title.className = "admin-notification__title";
                    title.textContent = state.title;
                    content.appendChild(title);
                    if (state.message) {
                        var message = document.createElement("span");
                        message.className = "admin-notification__message";
                        message.textContent = state.message;
                        content.appendChild(message);
                    }

                    var close = document.createElement("button");
                    close.type = "button";
                    close.className = "admin-notification__close";
                    close.setAttribute("aria-label", "Dismiss notification");
                    close.textContent = "×";
                    close.addEventListener("click", function () {
                        dismiss(notification);
                    });

                    notification.append(icon, content, close);
                    document.body.appendChild(notification);
                    present(notification);
                }
            };

            document.addEventListener("DOMContentLoaded", function () {
                var notification = document.getElementById("admin-toast");
                if (notification) {
                    present(notification);
                }
            });
        })();
        """#

    public func html(context: inout BuilderContext) -> Div {
        Div {
            Span {
                icon
            }
            .class(
                "admin-notification__icon admin-notification__icon--\(state.kind.rawValue)"
            )
            Span {
                Span(state.title).class("admin-notification__title")
                if !state.message.isEmpty {
                    Span(state.message)
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
            .onClick(
                "document.cookie='admin_notification=; Max-Age=0; path=/admin';var n=this.closest('#admin-toast');if(n){n.classList.remove('is-visible');n.classList.add('is-hidden');setTimeout(function(){n.remove()},220)}"
            )
        }
        .id("admin-toast")
        .class("admin-notification")
        .data("notification-inline", "true")
        .data("toast-type", state.kind.rawValue)
        .data("toast-title", state.title)
        .data("toast-message", state.message)
        .data("toast-position", state.position)
    }

    private var icon: SVG {
        switch state.kind {
        case .success: return FeatherIcons.checkCircle()
        case .info: return FeatherIcons.info()
        case .warning: return FeatherIcons.alertTriangle()
        case .error: return FeatherIcons.alertCircle()
        }
    }

    public func scripts() -> [String] {
        []
    }

    private static func javascriptString(_ value: String) -> String {
        let data = try? JSONEncoder().encode(value)
        return data.flatMap { String(data: $0, encoding: .utf8) } ?? "\"\""
    }
}
