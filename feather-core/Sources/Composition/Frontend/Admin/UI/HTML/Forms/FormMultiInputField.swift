import CSS
import FeatherContracts
import Foundation
import HTML
import SGML
import WebStandards

public struct FormMultiInputField: Component, FlowContent {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var values: [String]
        public var error: String?
        public var help: String?
        public var placeholder: String?
        public var id: String
        public var isRequired: Bool
        public var isDisabled: Bool
        public var wrapperClass: String?

        public init(
            name: String,
            label: String,
            values: [String] = [],
            error: String? = nil,
            help: String? = nil,
            placeholder: String? = nil,
            id: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            wrapperClass: String? = nil
        ) {
            self.name = name
            self.label = label
            self.values = values
            self.error = error
            self.help = help
            self.placeholder = placeholder
            self.id = id ?? name
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.wrapperClass = wrapperClass
        }
    }

    public var state: State

    public init(state: State) {
        self.state = state
    }

    public init(
        name: String,
        label: String,
        values: [String] = [],
        error: String? = nil,
        help: String? = nil,
        placeholder: String? = nil,
        id: String? = nil,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        wrapperClass: String? = nil
    ) {
        self.state = .init(
            name: name,
            label: label,
            values: values,
            error: error,
            help: help,
            placeholder: placeholder,
            id: id,
            isRequired: isRequired,
            isDisabled: isDisabled,
            wrapperClass: wrapperClass
        )
    }

    public func selectors() -> [any CSS.Selector] {
        Class("field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Custom("label .field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Class("form-multi-input-field__control") {
            MinHeight(48.px)
            Display(.flex)
            FlexWrap(.wrap)
            AlignItems(.center)
            Gap(6.px)
            Padding(top: 0.px, right: 8.px, bottom: 0.px, left: 8.px)
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(10.px)
            Background(color: .variable("cms-white"))
        }
        Custom(".form-multi-input-field__control:focus-within") {
            BorderColor(.variable("cms-gray-3"))
            UnsafeRawProperty(
                name: "outline",
                value: "2px solid var(--cms-gray-5)"
            )
            UnsafeRawProperty(name: "outline-offset", value: "1px")
        }
        Class("form-multi-input-field__chip") {
            Display(.inlineFlex)
            AlignItems(.center)
            Gap(4.px)
            BorderRadius(999.px)
            Padding(left: 10.px)
            Background(color: .variable("cms-gray-2"))
            Color(.variable("cms-strong-font"))
            FontSize(14.px)
        }
        Class("form-multi-input-field__remove") {
            Width(26.px)
            Height(26.px)
            Padding(0.px)
            Border(0.px)
            BorderRadius(999.px)
            Background(color: .transparent)
            Color(.variable("cms-light-font"))
            Cursor(.pointer)
        }
        Custom(
            ".form-multi-input-field__remove:hover, .form-multi-input-field__remove:focus-visible"
        ) {
            Background(color: .variable("cms-gray-3"))
            UnsafeRawProperty(name: "outline", value: "none")
        }
        Custom(".cms-form input.form-multi-input-field__input") {
            Flex(1)
            MinWidth(140.px)
            MinHeight(30.px)
            Padding(4.px)
            Border(0.px)
            Background(color: .transparent)
            Color(.variable("cms-strong-font"))
            UnsafeRawProperty(name: "outline", value: "none")
            UnsafeRawProperty(name: "box-shadow", value: "none")
        }
    }

    public func content() -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                Div {
                    for value in normalizedValues {
                        chip(value)
                    }
                    Input()
                        .type(.text)
                        .id(inputID)
                        .class("form-multi-input-field__input")
                        .autocomplete(.off)
                        .placeholder(state.placeholder)
                        .ariaDescribedBy(describedBy)
                        .ariaInvalid(state.error == nil ? .false : .true)
                        .if(state.error != nil) { $0.ariaErrorMessage(errorID) }
                        .if(state.isRequired && normalizedValues.isEmpty) {
                            $0.required()
                        }
                        .if(state.isDisabled) { $0.disabled() }
                }
                .class("form-multi-input-field__control")
            }
            .for(inputID)

            Div {
                for value in normalizedValues {
                    Input()
                        .type(.hidden)
                        .name(state.name)
                        .value(value)
                }
            }
            .class("form-multi-input-field__values")

            if let help = state.help {
                Span(help).id(helpID).class("field-help")
            }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
            Script(script())
        }
        .class("form-multi-input-field")
        .if(state.error != nil) { $0.class("has-error") }
        .if(state.wrapperClass != nil) {
            if let wrapperClass = state.wrapperClass {
                return $0.class(wrapperClass)
            }
            return $0
        }
    }

    private func fieldLabel() -> some BasicTag {
        Span {
            InlineText(state.label)
            if !state.isRequired {
                Span(" (Optional)").class("field-label__optional")
            }
        }
        .class("field-label")
    }

    private func chip(
        _ value: String
    ) -> some BasicTag {
        Span {
            Span(value).class("form-multi-input-field__chip-label")
            Button("×")
                .type(.button)
                .class("form-multi-input-field__remove")
                .ariaLabel("Remove \(value)")
                .data("value", value)
        }
        .class("form-multi-input-field__chip")
    }

    private var normalizedValues: [String] {
        var seen = Set<String>()
        return state.values.compactMap {
            let value = $0.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = value.lowercased()
            guard !value.isEmpty, seen.insert(key).inserted else { return nil }
            return value
        }
    }

    private var inputID: String { "\(state.id)-input" }
    private var helpID: String { "\(state.id)-help" }
    private var errorID: String { "\(state.id)-error" }

    private var describedBy: String? {
        [state.help == nil ? nil : helpID, state.error == nil ? nil : errorID]
            .compactMap { $0 }
            .joined(separator: " ")
            .emptyToNil
    }

    private func script() -> String {
        #"""
        (function () {
            function initialize(root) {
                if (root.dataset.bound === "1") return;
                root.dataset.bound = "1";

                var input = root.querySelector(".form-multi-input-field__input");
                var control = root.querySelector(".form-multi-input-field__control");
                var values = root.querySelector(".form-multi-input-field__values");
                if (!input || !control || !values) return;

                function currentValues() {
                    return Array.prototype.map.call(
                        values.querySelectorAll('input[type="hidden"]'),
                        function (element) { return element.value; }
                    );
                }

                function add(value) {
                    var normalized = value.trim();
                    if (!normalized) return;
                    var duplicate = currentValues().some(function (item) {
                        return item.toLowerCase() === normalized.toLowerCase();
                    });
                    if (duplicate) return;

                    var hidden = document.createElement("input");
                    hidden.type = "hidden";
                    hidden.name = root.dataset.name;
                    hidden.value = normalized;
                    values.append(hidden);

                    var chip = document.createElement("span");
                    chip.className = "form-multi-input-field__chip";
                    chip.innerHTML = '<span class="form-multi-input-field__chip-label"></span>' +
                        '<button type="button" class="form-multi-input-field__remove"></button>';
                    chip.querySelector(".form-multi-input-field__chip-label").textContent = normalized;
                    var remove = chip.querySelector(".form-multi-input-field__remove");
                    remove.textContent = "×";
                    remove.dataset.value = normalized;
                    remove.setAttribute("aria-label", "Remove " + normalized);
                    control.insertBefore(chip, input);
                    input.value = "";
                    input.required = false;
                }

                input.addEventListener("keydown", function (event) {
                    if (event.key === "Enter") {
                        event.preventDefault();
                        add(input.value);
                    }
                    if (event.key === ",") {
                        event.preventDefault();
                        add(input.value);
                    }
                    if (event.key === "Backspace" && !input.value && currentValues().length) {
                        var hidden = values.lastElementChild;
                        var chips = control.querySelectorAll(".form-multi-input-field__chip");
                        if (hidden) hidden.remove();
                        if (chips.length) chips[chips.length - 1].remove();
                        input.required = currentValues().length === 0;
                    }
                });

                input.addEventListener("input", function () {
                    var parts = input.value.split(",");
                    if (parts.length > 1) {
                        parts.slice(0, -1).forEach(add);
                        input.value = parts[parts.length - 1];
                    }
                });

                var form = root.closest("form");
                if (form) {
                    form.addEventListener("submit", function () {
                        add(input.value);
                    });
                }

                control.addEventListener("click", function (event) {
                    var remove = event.target.closest(".form-multi-input-field__remove");
                    if (!remove) return;
                    var valueToRemove = remove.dataset.value;
                    Array.prototype.forEach.call(values.querySelectorAll('input[type="hidden"]'), function (hidden) {
                        if (hidden.value === valueToRemove) hidden.remove();
                    });
                    remove.closest(".form-multi-input-field__chip").remove();
                    input.required = currentValues().length === 0;
                    input.focus();
                });
            }

            function initAll() {
                document.querySelectorAll(".form-multi-input-field").forEach(function (root) {
                    root.dataset.name = root.querySelector(".form-multi-input-field__values input")?.name || "\#(state.name)";
                    initialize(root);
                });
            }

            if (document.readyState === "loading") {
                document.addEventListener("DOMContentLoaded", initAll, { once: true });
            } else {
                initAll();
            }
        })();
        """#
    }
}
