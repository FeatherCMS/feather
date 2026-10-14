public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminFormGroup: Component {
    public let id: String
    public let title: String
    public let isOpen: Bool
    public let persistsState: Bool
    public let content: [any FlowContent]

    public init(
        id: String,
        title: String,
        isOpen: Bool = true,
        persistsState: Bool = true,
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.id = id
        self.title = title
        self.isOpen = isOpen
        self.persistsState = persistsState
        self.content = content()
    }

    public func selectors() -> [any Selector] {
        [
            Class("new-admin-form-group") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(16.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
            },
            Custom(".new-admin-form-group > summary") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(12.px)
                Cursor(.pointer)
                ListStyleType(.none)
            },
            Custom(
                ".new-admin-form-group > summary::-webkit-details-marker"
            ) {
                Display(.none)
            },
            Custom(".new-admin-form-group > summary h2") {
                Margin(0.px)
                FontSize(18.px)
            },
            Custom(".new-admin-form-group > summary::after") {
                Content(.string("\"\""))
                Width(10.px)
                Height(10.px)
                FlexShrink(0)
                UnsafeRawProperty(
                    name: "border-right",
                    value: "2px solid currentColor"
                )
                UnsafeRawProperty(
                    name: "border-bottom",
                    value: "2px solid currentColor"
                )
                UnsafeRawProperty(
                    name: "transform",
                    value: "translateY(-2px) rotate(-45deg)"
                )
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 140ms ease"
                )
            },
            Custom(
                ".new-admin-form-group[open] > summary::after"
            ) {
                UnsafeRawProperty(
                    name: "transform",
                    value: "translateY(-2px) rotate(45deg)"
                )
            },
            Custom(
                ".new-admin-form-group[open] > summary + .new-admin-form-group__content"
            ) {
                MarginTop(24.px)
            },
            Custom(".new-admin-form-group__content") {
                Display(.flex)
                FlexDirection(.column)
                Gap(18.px)
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Details {
        Details {
            Summary {
                H2(title)
            }
            Div {
                for item in content {
                    item
                }
            }
            .class("new-admin-form-group__content")
            if persistsState {
                Script(script())
            }
        }
        .if(isOpen) { $0.open() }
        .class("new-admin-form-group")
        .if(persistsState) {
            $0.data("new-admin-form-group", id)
        }
    }

    private func script() -> String {
        #"""
        (function() {
          if (window.__newAdminFormGroupInit) { return; }
          window.__newAdminFormGroupInit = true;

          var cookieName = "new_admin_collapsible_sections";
          var cookiePath = "; Max-Age=31536000; Path=/admin; SameSite=Lax";

          function readState() {
            var prefix = cookieName + "=";
            var cookie = document.cookie.split(";").map(function(value) {
              return value.trim();
            }).find(function(value) {
              return value.indexOf(prefix) === 0;
            });
            if (!cookie) { return {}; }

            try {
              return JSON.parse(decodeURIComponent(cookie.substring(prefix.length)));
            } catch (error) {
              return {};
            }
          }

          function writeState(state) {
            document.cookie = cookieName + "=" + encodeURIComponent(JSON.stringify(state)) + cookiePath;
          }

          function initialize() {
            var state = readState();
            document.querySelectorAll("[data-new-admin-form-group]").forEach(function(section) {
              var key = section.getAttribute("data-new-admin-form-group");
              if (!key) { return; }

              if (Object.prototype.hasOwnProperty.call(state, key)) {
                section.open = state[key] === true;
              }

              section.addEventListener("toggle", function() {
                state[key] = section.open;
                writeState(state);
              });
            });
          }

          if (document.readyState === "loading") {
            document.addEventListener("DOMContentLoaded", initialize);
          } else {
            initialize();
          }
        })();
        """#
    }
}
