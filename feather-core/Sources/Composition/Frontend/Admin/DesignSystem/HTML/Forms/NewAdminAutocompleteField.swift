import CSS
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminAutocompleteField: Component {
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

        public init(
            name: String,
            label: String,
            placeholder: String = "",
            options: [Option],
            error: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.placeholder = placeholder
            self.options = options
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
        let selected = state.options.first(where: \.isSelected)

        return Section {
            Label {
                Span {
                    Span(state.label)
                    if !state.isRequired {
                        Span("(optional)").class("field-optional")
                    }
                }
                Div {
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
                        .if(state.error != nil) { $0.ariaErrorMessage(errorID) }
                        .if(state.isRequired) { $0.required() }
                        .if(state.isDisabled) { $0.disabled() }
                        .if(selected != nil) { $0.value(selected?.label) }
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
            if let selected {
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
                    var hidden = root.querySelector(".new-admin-autocomplete__value");
                    var status = root.querySelector(".new-admin-autocomplete__status");
                    var source = root.querySelector(".new-admin-autocomplete__options");
                    if (!input || !toggle || !list || !source) { return; }
                    var options = [];
                    try { options = JSON.parse(source.textContent || "[]"); } catch (_) { options = []; }
                    var active = -1;
                    var open = false;

                    function visibleOptions() {
                        var query = (input.value || "").toLowerCase().trim();
                        return options.filter(function (item) {
                            return !query || item.label.toLowerCase().indexOf(query) >= 0 || item.value.toLowerCase().indexOf(query) >= 0;
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
                        input.value = item.label;
                        if (hidden) { hidden.value = item.value; }
                        else {
                            hidden = document.createElement("input");
                            hidden.type = "hidden";
                            hidden.name = root.dataset.name || "";
                            hidden.className = "new-admin-autocomplete__value";
                            hidden.value = item.value;
                            root.appendChild(hidden);
                        }
                        if (status) { status.textContent = item.label + " selected."; }
                        setOpen(false);
                    }

                    input.addEventListener("focus", function () { setOpen(true); });
                    input.addEventListener("input", function () {
                        if (hidden) { hidden.value = ""; }
                        active = 0;
                        setOpen(true);
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
