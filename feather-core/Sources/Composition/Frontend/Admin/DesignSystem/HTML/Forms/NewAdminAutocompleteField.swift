import CSS
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminAutocompleteField: Component {
    public enum SelectionMode: String, Sendable, Equatable {
        case single
        case multiple
    }

    public struct Option: Codable, Sendable, Hashable {
        public let label: String
        public let value: String
        public let isSelected: Bool

        public init(
            label: String,
            value: String,
            isSelected: Bool = false
        ) {
            self.label = label
            self.value = value
            self.isSelected = isSelected
        }
    }

    public struct State: Sendable {
        public let name: String
        public let label: String
        public let placeholder: String
        public let options: [Option]
        public let error: String?
        public let isRequired: Bool
        public let isDisabled: Bool
        public let selectionMode: SelectionMode

        public init(
            name: String,
            label: String,
            placeholder: String = "",
            options: [Option],
            error: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            selectionMode: SelectionMode = .single
        ) {
            self.name = name
            self.label = label
            self.placeholder = placeholder
            self.options = options
            self.error = error
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.selectionMode = selectionMode
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("new-admin-autocomplete") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Position(.relative)
            },
            Custom(".new-admin-autocomplete > label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(5.px)
                FontWeight(.normal)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Opacity(0.8)
            },
            Class("new-admin-autocomplete__control") {
                Display(.grid)
                GridTemplateColumns(
                    .tracks([.fraction(1.fr), .length(32.px)])
                )
                AlignItems(.center)
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 2.px, horizontal: 6.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom(".new-admin-autocomplete__control:focus-within") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom(".new-admin-autocomplete__input") {
                Width(100.percent)
                MinWidth(0.px)
                BoxSizing(.borderBox)
                Padding(vertical: 8.px, horizontal: 6.px)
                Border(0.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Outline(0.px, .none)
            },
            Class("new-admin-autocomplete__input-wrap") {
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(4.px)
                MinWidth(0.px)
            },
            Class("new-admin-autocomplete__selected") {
                Display(.inlineFlex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(4.px)
            },
            Class("new-admin-autocomplete__chip") {
                Display(.inlineFlex)
                AlignItems(.center)
                Gap(4.px)
                MaxWidth(100.percent)
                Padding(vertical: 3.px, horizontal: 8.px)
                BorderRadius(999.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontSize(0.875.rem)
            },
            Class("new-admin-autocomplete__chip-remove") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(20.px)
                Height(20.px)
                Padding(0.px)
                Border(0.px)
                BorderRadius(999.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom(".new-admin-autocomplete__chip-remove:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(1.px)
            },
            Class("new-admin-autocomplete__toggle") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(28.px)
                Height(28.px)
                Border(0.px)
                BorderRadius(6.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom(".new-admin-autocomplete__toggle:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(1.px)
            },
            Class("new-admin-autocomplete__chevron") {
                Display(.inlineBlock)
                Width(8.px)
                Height(8.px)
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
                    value: "translateY(-2px) rotate(45deg)"
                )
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 140ms ease"
                )
            },
            Custom(
                ".new-admin-autocomplete.is-open .new-admin-autocomplete__chevron"
            ) {
                UnsafeRawProperty(
                    name: "transform",
                    value: "translateY(2px) rotate(225deg)"
                )
            },
            Class("new-admin-autocomplete__list") {
                Position(.absolute)
                Top(100.percent)
                Left(0.px)
                Right(0.px)
                ZIndex(.number(20))
                Display(.none)
                MarginTop(4.px)
                Padding(4.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                MaxHeight(240.px)
                Overflow(.auto)
                ListStyle(.none)
            },
            Custom(
                ".new-admin-autocomplete.is-open .new-admin-autocomplete__list"
            ) {
                Display(.block)
            },
            Class("new-admin-autocomplete__option") {
                Display(.block)
                Padding(vertical: 8.px, horizontal: 10.px)
                BorderRadius(6.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
            },
            Custom(
                ".new-admin-autocomplete__option:hover, .new-admin-autocomplete__option.is-active"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Class("new-admin-autocomplete__empty") {
                Display(.block)
                Padding(vertical: 8.px, horizontal: 10.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom(".new-admin-autocomplete .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
            Custom(
                ".new-admin-autocomplete.has-error .new-admin-autocomplete__control"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
            Class("new-admin-autocomplete__status") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Overflow(.hidden)
                UnsafeRawProperty(name: "clip-path", value: "inset(50%)")
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        let errorID = "\(state.name)-error"
        let listID = "\(state.name)-options"
        let selectedOptions = state.options.filter(\.isSelected)
        let selected = selectedOptions.first

        return Section {
            Label {
                Span {
                    Span(state.label)
                    if !state.isRequired {
                        Span("(optional)").class("field-optional")
                    }
                }
                Div {
                    Div {
                        if state.selectionMode == .multiple {
                            Div {
                                for option in selectedOptions {
                                    Span {
                                        Span(option.label)
                                        Button("×")
                                            .type(.button)
                                            .class(
                                                "new-admin-autocomplete__chip-remove"
                                            )
                                            .data("value", option.value)
                                            .ariaLabel("Remove \(option.label)")
                                    }
                                    .class("new-admin-autocomplete__chip")
                                }
                            }
                            .class("new-admin-autocomplete__selected")
                        }
                        Input()
                            .type(.text)
                            .class("new-admin-autocomplete__input")
                            .id(state.name)
                            .placeholder(state.placeholder)
                            .autocomplete(.off)
                            .role("combobox")
                            .ariaAutoComplete(.list)
                            .ariaExpanded("false")
                            .ariaHasPopup(.listbox)
                            .ariaControls(listID)
                            .ariaInvalid(state.error == nil ? .false : .true)
                            .if(state.error != nil) {
                                $0.ariaErrorMessage(errorID)
                            }
                            .if(
                                state.isRequired
                                    && state.selectionMode == .single
                            ) { $0.required() }
                            .if(state.isDisabled) { $0.disabled() }
                            .if(
                                state.selectionMode == .single
                                    && selected != nil
                            ) { $0.value(selected?.label) }
                    }
                    .class("new-admin-autocomplete__input-wrap")
                    Button {
                        Span {}.class("new-admin-autocomplete__chevron")
                    }
                    .type(.button)
                    .class("new-admin-autocomplete__toggle")
                    .ariaLabel("Show options")
                    .ariaExpanded("false")
                    .ariaControls(listID)
                    .if(state.isDisabled) { $0.disabled() }
                }
                .class("new-admin-autocomplete__control")
            }
            .for(state.name)
            Ul {
                for option in state.options {
                    Li(option.label)
                        .class("new-admin-autocomplete__option")
                        .data("value", option.value)
                        .role("option")
                        .if(option.isSelected) { $0.class("is-selected") }
                }
            }
            .id(listID)
            .class("new-admin-autocomplete__list")
            .role("listbox")
            .ariaLabel(state.label)
            for selected in selectedOptions {
                Input()
                    .type(.hidden)
                    .name(state.name)
                    .value(selected.value)
                    .class("new-admin-autocomplete__value")
            }
            Div {}
                .class("new-admin-autocomplete__status")
                .role("status")
                .ariaLive(.polite)
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
            Script(optionsJSON()).type("application/json")
                .class(
                    "new-admin-autocomplete__options"
                )
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-autocomplete")
        .data("name", state.name)
        .data("mode", state.selectionMode.rawValue)
        .data("error-id", errorID)
    }

    public func scripts() -> [String] {
        [
            #"""
            (function () {
                function initialize(root) {
                    if (root.dataset.bound === "1") { return; }
                    root.dataset.bound = "1";
                    var input = root.querySelector(".new-admin-autocomplete__input");
                    var toggle = root.querySelector(".new-admin-autocomplete__toggle");
                    var list = root.querySelector(".new-admin-autocomplete__list");
                    var inputWrap = root.querySelector(".new-admin-autocomplete__input-wrap");
                    var selectedContainer = root.querySelector(".new-admin-autocomplete__selected");
                    var status = root.querySelector(".new-admin-autocomplete__status");
                    var source = root.querySelector(".new-admin-autocomplete__options");
                    if (!input || !toggle || !list || !source) { return; }
                    var multiple = root.dataset.mode === "multiple";
                    var options = [];
                    try { options = JSON.parse(source.textContent || "[]"); } catch (_) { options = []; }
                    var selectedValues = Array.prototype.map.call(
                        root.querySelectorAll(".new-admin-autocomplete__value"),
                        function (element) { return element.value; }
                    );
                    var active = -1;
                    var open = false;

                    function selectedOptions() {
                        return options.filter(function (item) {
                            return selectedValues.indexOf(item.value) >= 0;
                        });
                    }

                    function visibleOptions() {
                        var query = (input.value || "").toLowerCase().trim();
                        return options.filter(function (item) {
                            if (multiple && selectedValues.indexOf(item.value) >= 0) { return false; }
                            return !query || item.label.toLowerCase().indexOf(query) >= 0 || item.value.toLowerCase().indexOf(query) >= 0;
                        });
                    }

                    function syncHiddenInputs() {
                        var existing = root.querySelectorAll(".new-admin-autocomplete__value");
                        existing.forEach(function (element) { element.remove(); });
                        selectedValues.forEach(function (value) {
                            var hidden = document.createElement("input");
                            hidden.type = "hidden";
                            hidden.name = root.dataset.name || "";
                            hidden.value = value;
                            hidden.className = "new-admin-autocomplete__value";
                            root.appendChild(hidden);
                        });
                    }

                    function renderSelected() {
                        if (!multiple || !selectedContainer) { return; }
                        selectedContainer.innerHTML = "";
                        selectedOptions().forEach(function (item) {
                            var chip = document.createElement("span");
                            chip.className = "new-admin-autocomplete__chip";
                            var label = document.createElement("span");
                            label.textContent = item.label;
                            var remove = document.createElement("button");
                            remove.type = "button";
                            remove.className = "new-admin-autocomplete__chip-remove";
                            remove.dataset.value = item.value;
                            remove.setAttribute("aria-label", "Remove " + item.label);
                            remove.textContent = "×";
                            chip.append(label, remove);
                            selectedContainer.appendChild(chip);
                        });
                    }

                    function render() {
                        var matches = visibleOptions();
                        list.innerHTML = "";
                        if (!matches.length) {
                            var empty = document.createElement("li");
                            empty.className = "new-admin-autocomplete__empty";
                            empty.textContent = "No matches";
                            list.appendChild(empty);
                            active = -1;
                            return;
                        }
                        if (active >= matches.length) { active = matches.length - 1; }
                        matches.forEach(function (item, index) {
                            var option = document.createElement("li");
                            option.className = "new-admin-autocomplete__option" + (index === active ? " is-active" : "");
                            option.textContent = item.label;
                            option.dataset.value = item.value;
                            option.setAttribute("role", "option");
                            option.addEventListener("mousedown", function (event) {
                                event.preventDefault();
                                select(item);
                            });
                            list.appendChild(option);
                        });
                    }

                    function setOpen(value) {
                        open = value;
                        root.classList.toggle("is-open", open);
                        input.setAttribute("aria-expanded", String(open));
                        toggle.setAttribute("aria-expanded", String(open));
                        if (open) { render(); }
                    }

                    function select(item) {
                        if (multiple) {
                            if (selectedValues.indexOf(item.value) < 0) {
                                selectedValues.push(item.value);
                            }
                            input.value = "";
                            active = -1;
                            syncHiddenInputs();
                            renderSelected();
                            if (status) { status.textContent = item.label + " selected."; }
                            setOpen(true);
                            return;
                        }
                        input.value = item.label;
                        selectedValues = [item.value];
                        syncHiddenInputs();
                        if (status) { status.textContent = item.label + " selected."; }
                        setOpen(false);
                    }

                    function removeSelected(value) {
                        selectedValues = selectedValues.filter(function (item) { return item !== value; });
                        syncHiddenInputs();
                        renderSelected();
                        var removed = options.find(function (item) { return item.value === value; });
                        if (status && removed) { status.textContent = removed.label + " removed."; }
                    }

                    input.addEventListener("focus", function () { setOpen(true); });
                    input.addEventListener("input", function () {
                        if (!multiple) {
                            selectedValues = [];
                            syncHiddenInputs();
                        }
                        active = 0;
                        setOpen(true);
                    });
                    if (inputWrap && selectedContainer) {
                        selectedContainer.addEventListener("click", function (event) {
                            var target = event.target;
                            if (target && target.closest) {
                                var remove = target.closest(".new-admin-autocomplete__chip-remove");
                                if (remove) {
                                    removeSelected(remove.dataset.value || "");
                                    input.focus();
                                }
                            }
                        });
                    }
                    input.addEventListener("keydown", function (event) {
                        if (multiple && event.key === "Backspace" && !input.value && selectedValues.length > 0) {
                            event.preventDefault();
                            removeSelected(selectedValues[selectedValues.length - 1]);
                        }
                    });
                    input.addEventListener("keydown", function (event) {
                        var matches = visibleOptions();
                        if (event.key === "ArrowDown") { event.preventDefault(); active = Math.min(active + 1, matches.length - 1); render(); }
                        if (event.key === "ArrowUp") { event.preventDefault(); active = Math.max(active - 1, 0); render(); }
                        if (event.key === "Enter" && open && matches[active]) { event.preventDefault(); select(matches[active]); }
                        if (event.key === "Escape") { setOpen(false); }
                    });
                    toggle.addEventListener("mousedown", function (event) { event.preventDefault(); });
                    toggle.addEventListener("click", function () {
                        setOpen(!open);
                        if (open) { input.focus(); }
                    });
                    document.addEventListener("mousedown", function (event) { if (!root.contains(event.target)) { setOpen(false); } });
                    renderSelected();
                    syncHiddenInputs();
                }

                function initializeAll() { document.querySelectorAll(".new-admin-autocomplete").forEach(initialize); }
                if (document.readyState === "loading") { document.addEventListener("DOMContentLoaded", initializeAll, { once: true }); }
                else { initializeAll(); }
            })();
            """#
        ]
    }

    private func optionsJSON() -> String {
        guard let data = try? JSONEncoder().encode(state.options),
            let json = String(data: data, encoding: .utf8)
        else { return "[]" }
        return json
    }
}
