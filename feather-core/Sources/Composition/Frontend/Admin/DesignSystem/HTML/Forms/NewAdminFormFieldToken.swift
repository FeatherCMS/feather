public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

/// A form field for entering a list of free-form values as removable tokens.
public struct NewAdminFormFieldToken: Component {
    public struct State: Sendable {
        public let name: String
        public let label: String
        public let placeholder: String
        public let tokens: [String]
        public let error: String?
        public let isRequired: Bool
        public let isDisabled: Bool

        public init(
            name: String,
            label: String,
            placeholder: String = "",
            tokens: [String] = [],
            error: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.placeholder = placeholder
            self.tokens = tokens
            self.error = error
            self.isRequired = isRequired
            self.isDisabled = isDisabled
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-token-field") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Position(.relative)
            },
            Custom(".new-admin-token-field > label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Class("new-admin-token-field__control") {
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(4.px)
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 4.px, horizontal: 6.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom(".new-admin-token-field__control:focus-within") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Accents.Primary.border))
                )
                OutlineOffset(2.px)
            },
            Class("new-admin-token-field__input") {
                Flex(1)
                MinWidth(120.px)
                BoxSizing(.borderBox)
                Padding(vertical: 5.px, horizontal: 4.px)
                Border(0.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontSize(1.rem)
                LineHeight(1.2)
                Outline(0.px, .none)
            },
            Class("new-admin-token-field__token") {
                Display(.inlineFlex)
                AlignItems(.center)
                Gap(6.px)
                MaxWidth(100.percent)
                Padding(top: 5.px, right: 8.px, bottom: 5.px, left: 12.px)
                BorderRadius(999.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontSize(0.875.rem)
            },
            Class("new-admin-token-field__remove") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(22.px)
                Height(22.px)
                BoxSizing(.borderBox)
                Padding(0.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(999.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(1.rem)
                Cursor(.pointer)
            },
            Custom(".new-admin-token-field__remove:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(1.px)
            },
            Custom(".new-admin-token-field .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
            Custom(
                ".new-admin-token-field.has-error .new-admin-token-field__control"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        let errorID = "\(state.name)-error"

        return Section {
            Label {
                context.build(
                    NewAdminFormFieldLabel(
                        text: state.label,
                        isRequired: state.isRequired
                    )
                )
                Div {
                    for token in state.tokens {
                        Span {
                            Span(token).class("new-admin-token-field__value")
                            Button("×")
                                .type(.button)
                                .class("new-admin-token-field__remove")
                                .data("value", token)
                                .ariaLabel("Remove \(token)")
                        }
                        .class("new-admin-token-field__token")
                    }
                    Input()
                        .type(.text)
                        .class("new-admin-token-field__input")
                        .id(state.name)
                        .placeholder(state.placeholder)
                        .autocomplete(.off)
                        .ariaInvalid(state.error == nil ? .false : .true)
                        .if(state.error != nil) {
                            $0.ariaErrorMessage(errorID)
                        }
                        .if(state.isDisabled) { $0.disabled() }
                }
                .class("new-admin-token-field__control")
            }
            .for(state.name)
            for token in state.tokens {
                Input()
                    .type(.hidden)
                    .name(state.name)
                    .value(token)
                    .class("new-admin-token-field__value-input")
            }
            Div {}
                .class("new-admin-token-field__status")
                .role("status")
                .ariaLive(.polite)
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-token-field")
        .data("name", state.name)
    }

    public func scripts() -> [String] {
        [
            #"""
            (function () {
                function initialize(root) {
                    if (root.dataset.bound === "1") { return; }
                    root.dataset.bound = "1";
                    var input = root.querySelector(".new-admin-token-field__input");
                    var control = root.querySelector(".new-admin-token-field__control");
                    var status = root.querySelector(".new-admin-token-field__status");
                    if (!input || !control) { return; }

                    function hiddenInputs() {
                        return root.querySelectorAll(".new-admin-token-field__value-input");
                    }

                    function values() {
                        return Array.prototype.map.call(hiddenInputs(), function (element) {
                            return element.value;
                        });
                    }

                    function render() {
                        var current = values();
                        root.querySelectorAll(".new-admin-token-field__token").forEach(function (token) {
                            token.remove();
                        });
                        current.forEach(function (value) {
                            var token = document.createElement("span");
                            token.className = "new-admin-token-field__token";
                            var label = document.createElement("span");
                            label.className = "new-admin-token-field__value";
                            label.textContent = value;
                            var remove = document.createElement("button");
                            remove.type = "button";
                            remove.className = "new-admin-token-field__remove";
                            remove.dataset.value = value;
                            remove.setAttribute("aria-label", "Remove " + value);
                            remove.textContent = "×";
                            token.append(label, remove);
                            control.insertBefore(token, input);
                        });
                    }

                    function add(value) {
                        value = (value || "").trim();
                        if (!value || values().indexOf(value) >= 0) { return; }
                        var hidden = document.createElement("input");
                        hidden.type = "hidden";
                        hidden.name = root.dataset.name || "";
                        hidden.value = value;
                        hidden.className = "new-admin-token-field__value-input";
                        root.appendChild(hidden);
                        input.value = "";
                        render();
                        if (status) { status.textContent = value + " added."; }
                    }

                    function remove(value) {
                        hiddenInputs().forEach(function (element) {
                            if (element.value === value) { element.remove(); }
                        });
                        render();
                        if (status) { status.textContent = value + " removed."; }
                    }

                    input.addEventListener("keydown", function (event) {
                        if (event.key === "Enter" || event.key === ",") {
                            event.preventDefault();
                            add(input.value);
                        } else if (event.key === "Backspace" && !input.value) {
                            var current = values();
                            if (current.length) { remove(current[current.length - 1]); }
                        }
                    });
                    input.addEventListener("blur", function () { add(input.value); });
                    control.addEventListener("click", function (event) {
                        var target = event.target;
                        var button = target && target.closest ? target.closest(".new-admin-token-field__remove") : null;
                        if (button) {
                            event.preventDefault();
                            event.stopPropagation();
                            remove(button.dataset.value || "");
                        }
                    });
                    var form = root.closest("form");
                    if (form) {
                        form.addEventListener("submit", function () { add(input.value); });
                    }
                    render();
                }

                function initializeAll() {
                    document.querySelectorAll(".new-admin-token-field").forEach(initialize);
                }
                if (document.readyState === "loading") {
                    document.addEventListener("DOMContentLoaded", initializeAll, { once: true });
                } else {
                    initializeAll();
                }
            })();
            """#
        ]
    }
}
