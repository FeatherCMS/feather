public import CSS
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminFormFieldMultiInput: Component {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var values: [String]
        public var error: String?
        public var help: String?
        public var placeholder: String?
        public var isRequired: Bool
        public var isDisabled: Bool
        public var commitsOnComma: Bool

        public init(
            name: String,
            label: String,
            values: [String] = [],
            error: String? = nil,
            help: String? = nil,
            placeholder: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            commitsOnComma: Bool = true
        ) {
            self.name = name
            self.label = label
            self.values = values
            self.error = error
            self.help = help
            self.placeholder = placeholder
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.commitsOnComma = commitsOnComma
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-multi-input") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Position(.relative)
            },
            Custom(".new-admin-multi-input > label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Class("new-admin-multi-input__control") {
                Display(.grid)
                GridTemplateColumns(.tracks([.fraction(1.fr)]))
                AlignItems(.center)
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 0.px, horizontal: 6.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom(".new-admin-multi-input__control:focus-within") {
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
            Class("new-admin-multi-input__input-wrap") {
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(4.px)
                MinWidth(0.px)
            },
            Class("new-admin-multi-input__input") {
                Width(100.percent)
                MinWidth(0.px)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 6.px)
                Border(0.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontSize(1.rem)
                LineHeight(1.2)
                Outline(0.px, .none)
                UnsafeRawProperty(name: "box-shadow", value: "none")
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(name: "-webkit-appearance", value: "none")
            },
            Custom(
                ".new-admin-multi-input__input:focus, .new-admin-multi-input__input:focus-visible"
            ) {
                UnsafeRawProperty(name: "outline", value: "none !important")
                UnsafeRawProperty(
                    name: "box-shadow",
                    value: "none !important"
                )
                UnsafeRawProperty(name: "-webkit-appearance", value: "none")
                UnsafeRawProperty(name: "appearance", value: "none")
            },
            Class("new-admin-multi-input__selected") {
                Display(.inlineFlex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(8.px)
                Width(100.percent)
                BoxSizing(.borderBox)
            },
            Custom(".new-admin-multi-input__selected:empty") {
                Display(.none)
            },
            Class("new-admin-multi-input__chip") {
                Display(.inlineFlex)
                AlignItems(.center)
                Gap(6.px)
                MaxWidth(100.percent)
                Padding(top: 5.px, right: 12.px, bottom: 5.px, left: 16.px)
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
            Class("new-admin-multi-input__chip-remove") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(24.px)
                Height(24.px)
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
            Custom(".new-admin-multi-input__chip-remove:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(1.px)
            },
            Custom(".new-admin-multi-input .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
            Custom(
                ".new-admin-multi-input.has-error .new-admin-multi-input__control"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
            Class("new-admin-multi-input__status") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Overflow(.hidden)
                UnsafeRawProperty(name: "clip-path", value: "inset(50%)")
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        Section {
            Label {
                context.build(
                    NewAdminFormFieldLabel(
                        text: state.label,
                        isRequired: state.isRequired
                    )
                )
                Div {
                    for value in normalizedValues {
                        Span {
                            Span(value)
                            Button("×")
                                .type(.button)
                                .class(
                                    "new-admin-multi-input__chip-remove"
                                )
                                .data("value", value)
                                .ariaLabel("Remove \(value)")
                        }
                        .class("new-admin-multi-input__chip")
                    }
                }
                .class("new-admin-multi-input__selected")
                Div {
                    Div {
                        Input()
                            .type(.text)
                            .class("new-admin-multi-input__input")
                            .id(inputID)
                            .placeholder(state.placeholder)
                            .autocomplete(.off)
                            .ariaInvalid(
                                state.error == nil ? .false : .true
                            )
                            .if(state.error != nil) {
                                $0.ariaErrorMessage(errorID)
                            }
                            .if(
                                state.isRequired && normalizedValues.isEmpty
                            ) {
                                $0.required()
                            }
                            .if(state.isDisabled) { $0.disabled() }
                    }
                    .class("new-admin-multi-input__input-wrap")
                }
                .class("new-admin-multi-input__control")
            }
            .for(inputID)
            for value in normalizedValues {
                Input()
                    .type(.hidden)
                    .name(state.name)
                    .value(value)
                    .class("new-admin-multi-input__value")
                    .if(state.isDisabled) { $0.disabled() }
            }
            Div {}
                .class("new-admin-multi-input__status")
                .role("status")
                .ariaLive(.polite)
            if let help = state.help {
                context.build(NewAdminFormFieldHelp(help))
            }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .if(state.isDisabled) { $0.class("is-disabled") }
        .class("new-admin-multi-input", "form-multi-input-field")
        .data("name", state.name)
        .data("required", state.isRequired ? "true" : "false")
        .data("commits-on-comma", state.commitsOnComma ? "true" : "false")
    }

    public func scripts() -> [String] {
        [
            #"""
            (function () {
                function initialize(root) {
                    if (root.dataset.bound === "1") { return; }
                    root.dataset.bound = "1";

                    var input = root.querySelector(".new-admin-multi-input__input");
                    var selectedContainer = root.querySelector(".new-admin-multi-input__selected");
                    var status = root.querySelector(".new-admin-multi-input__status");
                    if (!input || !selectedContainer) { return; }

                    var selectedValues = Array.prototype.map.call(
                        root.querySelectorAll(".new-admin-multi-input__value"),
                        function (element) { return element.value; }
                    );
                    var required = root.dataset.required === "true";
                    var commitsOnComma = root.dataset.commitsOnComma === "true";

                    function normalize(value) {
                        return String(value || "").trim();
                    }

                    function updateRequired() {
                        input.required = required && !input.disabled && selectedValues.length === 0;
                    }

                    function syncHiddenInputs() {
                        root.querySelectorAll(".new-admin-multi-input__value").forEach(function (element) {
                            element.remove();
                        });
                        selectedValues.forEach(function (value) {
                            var hidden = document.createElement("input");
                            hidden.type = "hidden";
                            hidden.name = root.dataset.name || "";
                            hidden.value = value;
                            hidden.disabled = input.disabled;
                            hidden.className = "new-admin-multi-input__value";
                            root.appendChild(hidden);
                        });
                    }

                    function renderSelected() {
                        selectedContainer.innerHTML = "";
                        selectedValues.forEach(function (value) {
                            var chip = document.createElement("span");
                            chip.className = "new-admin-multi-input__chip";
                            var label = document.createElement("span");
                            label.textContent = value;
                            var remove = document.createElement("button");
                            remove.type = "button";
                            remove.className = "new-admin-multi-input__chip-remove";
                            remove.dataset.value = value;
                            remove.setAttribute("aria-label", "Remove " + value);
                            remove.textContent = "×";
                            chip.append(label, remove);
                            selectedContainer.appendChild(chip);
                        });
                    }

                    function add(value) {
                        if (input.disabled) { return false; }
                        var normalized = normalize(value);
                        if (!normalized) { return false; }
                        var duplicate = selectedValues.some(function (item) {
                            return item.toLowerCase() === normalized.toLowerCase();
                        });
                        input.value = "";
                        if (duplicate) {
                            if (status) { status.textContent = normalized + " is already added."; }
                            return false;
                        }
                        selectedValues.push(normalized);
                        syncHiddenInputs();
                        renderSelected();
                        updateRequired();
                        if (status) { status.textContent = normalized + " added."; }
                        return true;
                    }

                    function removeSelected(value) {
                        var removed = selectedValues.find(function (item) {
                            return item === value;
                        });
                        selectedValues = selectedValues.filter(function (item) {
                            return item !== value;
                        });
                        syncHiddenInputs();
                        renderSelected();
                        updateRequired();
                        if (status && removed) { status.textContent = removed + " removed."; }
                    }

                    input.addEventListener("keydown", function (event) {
                        if (event.key === "Enter" || (commitsOnComma && event.key === ",")) {
                            event.preventDefault();
                            add(input.value);
                            return;
                        }
                        if (event.key === "Backspace" && !input.value && selectedValues.length > 0) {
                            event.preventDefault();
                            removeSelected(selectedValues[selectedValues.length - 1]);
                        }
                    });

                    input.addEventListener("input", function () {
                        if (!commitsOnComma) { return; }
                        var parts = input.value.split(",");
                        if (parts.length <= 1) { return; }
                        var remainder = parts.pop();
                        parts.forEach(add);
                        input.value = remainder;
                    });

                    selectedContainer.addEventListener("click", function (event) {
                        var target = event.target;
                        if (!target || !target.closest) { return; }
                        var remove = target.closest(".new-admin-multi-input__chip-remove");
                        if (!remove) { return; }
                        event.preventDefault();
                        event.stopPropagation();
                        removeSelected(remove.dataset.value || "");
                        input.focus();
                    });

                    var form = root.closest("form");
                    if (form) {
                        form.addEventListener("submit", function () {
                            add(input.value);
                        });
                    }

                    root.addEventListener("webapp:multi-input-set-enabled", function (event) {
                        var isEnabled = !!(event.detail && event.detail.isEnabled);
                        if (event.detail && typeof event.detail.isRequired === "boolean") {
                            required = event.detail.isRequired;
                            root.dataset.required = String(required);
                        }
                        input.disabled = !isEnabled;
                        root.setAttribute("aria-disabled", String(!isEnabled));
                        root.classList.toggle("is-disabled", !isEnabled);
                        if (!isEnabled) { input.value = ""; }
                        syncHiddenInputs();
                        updateRequired();
                    });

                    renderSelected();
                    syncHiddenInputs();
                    updateRequired();
                }

                function initializeAll() {
                    document.querySelectorAll(".new-admin-multi-input").forEach(initialize);
                }

                if (document.readyState === "loading") {
                    document.addEventListener("DOMContentLoaded", initializeAll, { once: true });
                }
                else {
                    initializeAll();
                }
            })();
            """#
        ]
    }

    private var normalizedValues: [String] {
        var seen = Set<String>()
        return state.values.compactMap {
            let value = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !value.isEmpty, seen.insert(value.lowercased()).inserted
            else { return nil }
            return value
        }
    }

    private var inputID: String {
        "\(state.name.replacingOccurrences(of: "[]", with: ""))-input"
    }

    private var errorID: String {
        "\(inputID)-error"
    }
}
