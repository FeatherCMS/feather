public import CSS
import Foundation
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminFormFieldSelectAutocomplete: Component {
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
        public let selectedValues: [String]
        public let error: String?
        public let help: String?
        public let isRequired: Bool
        public let isDisabled: Bool
        public let selectionMode: SelectionMode
        public let submitsValues: Bool
        public let remoteSourceURL: String?
        public let remoteQueryParameter: String
        public let remoteMinimumQueryLength: Int

        public init(
            name: String,
            label: String,
            placeholder: String = "",
            options: [Option],
            selectedValues: [String] = [],
            error: String? = nil,
            help: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            selectionMode: SelectionMode = .single,
            submitsValues: Bool = true,
            remoteSourceURL: String? = nil,
            remoteQueryParameter: String = "q",
            remoteMinimumQueryLength: Int = 2
        ) {
            self.name = name
            self.label = label
            self.placeholder = placeholder
            self.options = options
            self.selectedValues = selectedValues
            self.error = error
            self.help = help
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.selectionMode = selectionMode
            self.submitsValues = submitsValues
            self.remoteSourceURL = remoteSourceURL
            self.remoteQueryParameter = remoteQueryParameter
            self.remoteMinimumQueryLength = remoteMinimumQueryLength
        }
    }

    public let state: State
    private var isRemovalLabel = false

    public init(state: State) {
        self.state = state
    }

    public func setAsRemoveConfirmationLabel(_ condition: Bool = true) -> Self {
        var field = self
        field.isRemovalLabel = condition
        return field
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-autocomplete") {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Position(.relative)
            },
            Custom(".admin-autocomplete > label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Class("admin-autocomplete__control") {
                Display(.grid)
                GridTemplateColumns(
                    .tracks([.fraction(1.fr), .length(32.px)])
                )
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
            Custom(".admin-autocomplete__control:focus-within") {
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
            Custom(".admin-autocomplete__input") {
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
                ".admin-autocomplete__input:focus, .admin-autocomplete__input:focus-visible"
            ) {
                UnsafeRawProperty(name: "outline", value: "none !important")
                UnsafeRawProperty(name: "box-shadow", value: "none !important")
                UnsafeRawProperty(name: "-webkit-appearance", value: "none")
                UnsafeRawProperty(name: "appearance", value: "none")
            },
            Class("admin-autocomplete__input-wrap") {
                Display(.flex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(4.px)
                MinWidth(0.px)
            },
            Class("admin-autocomplete__selected") {
                Display(.inlineFlex)
                FlexWrap(.wrap)
                AlignItems(.center)
                Gap(8.px)
                Width(100.percent)
                BoxSizing(.borderBox)
            },
            Custom(".admin-autocomplete__selected:empty") {
                Display(.none)
            },
            Class("admin-autocomplete__chip") {
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
            Class("admin-autocomplete__chip-remove") {
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
            Custom(".admin-autocomplete__chip-remove:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(1.px)
            },
            Class("admin-autocomplete__toggle") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(28.px)
                Height(28.px)
                Border(0.px)
                BorderRadius(6.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Outline(0.px, .none)
                Cursor(.pointer)
            },
            Class("admin-autocomplete__chevron") {
                Display(.inlineBlock)
                Width(28.px)
                Height(28.px)
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value:
                        "calc(100% - 15px) 50%, calc(100% - 10px) 50%"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(
                    name: "background-repeat",
                    value: "no-repeat"
                )
                UnsafeRawProperty(
                    name: "transition",
                    value: "transform 140ms ease"
                )
            },
            Custom(
                ".admin-autocomplete.is-open .admin-autocomplete__chevron"
            ) {
                UnsafeRawProperty(
                    name: "transform",
                    value: "rotate(180deg)"
                )
            },
            Class("admin-autocomplete__list") {
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
                ".admin-autocomplete.is-open .admin-autocomplete__list"
            ) {
                Display(.block)
            },
            Class("admin-autocomplete__option") {
                Display(.block)
                Padding(vertical: 8.px, horizontal: 10.px)
                BorderRadius(6.px)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
            },
            Custom(
                ".admin-autocomplete__option:hover, .admin-autocomplete__option.is-active"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Class("admin-autocomplete__empty") {
                Display(.block)
                Padding(vertical: 8.px, horizontal: 10.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom(".admin-autocomplete .field-error") {
                Color(.red)
                FontSize(0.86.rem)
            },
            Custom(
                ".admin-autocomplete.has-error .admin-autocomplete__control"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
            },
            Class("admin-autocomplete__status") {
                Position(.absolute)
                Width(1.px)
                Height(1.px)
                Overflow(.hidden)
                UnsafeRawProperty(name: "clip-path", value: "inset(50%)")
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        let errorID = "\(state.name)-error"
        let listID = "\(state.name)-options"
        let selectedValues = state.selectedValues
            + state.options.filter(\.isSelected).map(\.value).filter {
                !state.selectedValues.contains($0)
            }
        let selectedOptions = selectedValues.map { value in
            state.options.first(where: { $0.value == value })
                ?? Option(
                    label: state.remoteSourceURL == nil ? value : "Loading…",
                    value: value,
                    isSelected: true
                )
        }
        let selected = selectedOptions.first

        return Section {
            Label {
                context.build(
                    AdminFormFieldLabel(
                        text: state.label,
                        isRequired: state.isRequired
                    )
                )
                if state.selectionMode == .multiple {
                    Div {
                        for option in selectedOptions {
                            Span {
                                Span(option.label)
                                Button("×")
                                    .type(.button)
                                    .class(
                                        "admin-autocomplete__chip-remove"
                                    )
                                    .data("value", option.value)
                                    .ariaLabel("Remove \(option.label)")
                            }
                            .class("admin-autocomplete__chip")
                        }
                    }
                    .class("admin-autocomplete__selected")
                }
                Div {
                    Div {
                        Input()
                            .type(.text)
                            .class("admin-autocomplete__input")
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
                                state.isRequired && selectedOptions.isEmpty
                            ) { $0.required() }
                            .if(state.isDisabled) { $0.disabled() }
                            .if(
                                state.selectionMode == .single
                                    && selected != nil
                            ) { $0.value(selected?.label) }
                    }
                    .class("admin-autocomplete__input-wrap")
                    Button {
                        Span {}.class("admin-autocomplete__chevron")
                    }
                    .type(.button)
                    .class("admin-autocomplete__toggle")
                    .ariaLabel("Show options")
                    .ariaExpanded("false")
                    .ariaControls(listID)
                    .if(state.isDisabled) { $0.disabled() }
                }
                .class("admin-autocomplete__control")
            }
            .for(state.name)
            Ul {
                for option in state.options {
                    Li(option.label)
                        .class("admin-autocomplete__option")
                        .data("value", option.value)
                        .role("option")
                        .if(option.isSelected) { $0.class("is-selected") }
                }
            }
            .id(listID)
            .class("admin-autocomplete__list")
            .role("listbox")
            .ariaLabel(state.label)
            for selected in selectedOptions {
                Input()
                    .type(.hidden)
                    .value(selected.value)
                    .class("admin-autocomplete__value")
                    .if(state.submitsValues) { $0.name(state.name) }
            }
            Div {}
                .class("admin-autocomplete__status")
                .role("status")
                .ariaLive(.polite)
            if let help = state.help {
                context.build(AdminFormFieldHelp(help))
            }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
            Script(optionsJSON()).type("application/json")
                .class(
                    "admin-autocomplete__options"
                )
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("admin-autocomplete")
        .setAsRemoveConfirmationLabel(isRemovalLabel)
        .data("name", state.name)
        .data("mode", state.selectionMode.rawValue)
        .data("required", state.isRequired ? "true" : "false")
        .data("submits-values", state.submitsValues ? "true" : "false")
        .if(state.remoteSourceURL != nil) {
            $0.data("source-url", state.remoteSourceURL ?? "")
                .data("source-query-parameter", state.remoteQueryParameter)
                .data(
                    "source-minimum-query-length",
                    String(state.remoteMinimumQueryLength)
                )
        }
        .data("error-id", errorID)
    }

    public func scripts() -> [String] {
        [
            #"""
            (function () {
                function initialize(root) {
                    if (root.dataset.bound === "1") { return; }
                    root.dataset.bound = "1";
                    var input = root.querySelector(".admin-autocomplete__input");
                    var toggle = root.querySelector(".admin-autocomplete__toggle");
                    var list = root.querySelector(".admin-autocomplete__list");
                    var inputWrap = root.querySelector(".admin-autocomplete__input-wrap");
                    var selectedContainer = root.querySelector(".admin-autocomplete__selected");
                    var status = root.querySelector(".admin-autocomplete__status");
                    var source = root.querySelector(".admin-autocomplete__options");
                    if (!input || !toggle || !list || !source) { return; }
                    var multiple = root.dataset.mode === "multiple";
                    var required = root.dataset.required === "true";
                    var submitsValues = root.dataset.submitsValues === "true";
                    var sourceURL = root.dataset.sourceUrl || "";
                    var sourceQueryParameter = root.dataset.sourceQueryParameter || "q";
                    var sourceMinimumQueryLength = parseInt(root.dataset.sourceMinimumQueryLength || "2", 10);
                    var requestSequence = 0;
                    var requestTimer = null;
                    var isLoadingOptions = !!sourceURL;
                    var options = [];
                    var remoteBaseOptions = null;
                    try { options = JSON.parse(source.textContent || "[]"); } catch (_) { options = []; }
                    var selectedOptionCache = options.filter(function (item) { return item.isSelected; });
                    if (sourceURL) {
                        selectedOptionCache.forEach(function (item) {
                            if (item.label === item.value) { item.label = "Loading…"; }
                        });
                    }
                    var selectedValues = Array.prototype.map.call(
                        root.querySelectorAll(".admin-autocomplete__value"),
                        function (element) { return element.value; }
                    );
                    var active = -1;
                    var open = false;
                    var searchQueryOverride = null;

                    function selectedOptions() {
                        return selectedValues.map(function (value) {
                            return selectedOptionCache.find(function (item) {
                                return item.value === value;
                            }) || options.find(function (item) {
                                return item.value === value;
                            }) || { label: sourceURL ? "Loading…" : value, value: value };
                        });
                    }

                    function cacheSelectedOptions(items) {
                        items.forEach(function (item) {
                            var existing = selectedOptionCache.findIndex(function (option) {
                                return option.value === item.value;
                            });
                            if (existing >= 0) { selectedOptionCache[existing] = item; }
                            else { selectedOptionCache.push(item); }
                        });
                    }

                    function visibleOptions() {
                        var query = (searchQueryOverride === null
                            ? (input.value || "")
                            : searchQueryOverride).toLowerCase().trim();
                        return options.filter(function (item) {
                            if (multiple && selectedValues.indexOf(item.value) >= 0) { return false; }
                            return !query || item.label.toLowerCase().indexOf(query) >= 0 || item.value.toLowerCase().indexOf(query) >= 0;
                        });
                    }

                    function normalizeRemoteOptions(payload) {
                        var values = Array.isArray(payload)
                            ? payload
                            : (payload && Array.isArray(payload.items) ? payload.items : []);
                        return values.map(function (item) {
                            return Object.assign({}, item, {
                                label: String(item.label || item.value || item.name || ""),
                                value: String(item.id || item.value || "")
                            });
                        }).filter(function (item) {
                            return item.label && item.value;
                        });
                    }

                    function fetchRemoteOptions(forceBaseList) {
                        if (!sourceURL) { return; }
                        var query = forceBaseList ? "" : (input.value || "").trim();
                        var sequence = ++requestSequence;
                        if (requestTimer) { window.clearTimeout(requestTimer); }
                        if (query.length < sourceMinimumQueryLength) {
                            if (remoteBaseOptions) {
                                isLoadingOptions = false;
                                options = remoteBaseOptions;
                                active = options.length ? 0 : -1;
                                render();
                                return;
                            }
                            query = "";
                        }
                        isLoadingOptions = true;
                        render();
                        requestTimer = window.setTimeout(function () {
                            var separator = sourceURL.indexOf("?") >= 0 ? "&" : "?";
                            var url = sourceURL;
                            if (query) {
                                url += separator + encodeURIComponent(sourceQueryParameter) + "=" + encodeURIComponent(query);
                                separator = "&";
                            }
                            if (selectedValues.length) {
                                url += separator + "excludeIds=" + encodeURIComponent(selectedValues.join(","));
                            }
                            fetch(url, { credentials: "include", headers: { "Accept": "application/json" } })
                                .then(function (response) {
                                    if (!response.ok) { throw new Error("Location lookup failed"); }
                                    return response.json();
                                })
                                .then(function (payload) {
                                    if (sequence !== requestSequence) { return; }
                                    isLoadingOptions = false;
                                    options = normalizeRemoteOptions(payload);
                                    if (!query) { remoteBaseOptions = options.slice(); }
                                    cacheSelectedOptions(options.filter(function (item) {
                                        return selectedValues.indexOf(item.value) >= 0;
                                    }));
                                    active = options.length ? 0 : -1;
                                    render();
                                })
                                .catch(function () {
                                    if (sequence !== requestSequence) { return; }
                                    isLoadingOptions = false;
                                    options = [];
                                    active = -1;
                                    render();
                                });
                        }, 220);
                    }

                    function fetchRemoteSelectedOptions() {
                        if (!sourceURL || !selectedValues.length) { return; }
                        var requestedValues = selectedValues.slice();
                        var url = sourceURL + (sourceURL.indexOf("?") >= 0 ? "&" : "?")
                            + "ids=" + encodeURIComponent(requestedValues.join(","));
                        fetch(url, { credentials: "include", headers: { "Accept": "application/json" } })
                            .then(function (response) {
                                if (!response.ok) { throw new Error("Selected option lookup failed"); }
                                return response.json();
                            })
                            .then(function (payload) {
                                var resolved = normalizeRemoteOptions(payload);
                                cacheSelectedOptions(resolved);
                                requestedValues.forEach(function (value) {
                                    if (!resolved.some(function (item) { return item.value === value; })) {
                                        cacheSelectedOptions([{ value: value, label: "Unavailable" }]);
                                    }
                                });
                                if (!multiple) {
                                    var selected = selectedOptions()[0];
                                    input.value = selected ? selected.label : "";
                                }
                                renderSelected();
                            })
                            .catch(function () {
                                requestedValues.forEach(function (value) {
                                    cacheSelectedOptions([{ value: value, label: "Unavailable" }]);
                                });
                                if (!multiple) {
                                    var selected = selectedOptions()[0];
                                    input.value = selected ? selected.label : "";
                                }
                                renderSelected();
                            });
                    }

                    function syncHiddenInputs() {
                        var existing = root.querySelectorAll(".admin-autocomplete__value");
                        existing.forEach(function (element) { element.remove(); });
                        selectedValues.forEach(function (value) {
                            var hidden = document.createElement("input");
                            hidden.type = "hidden";
                            if (submitsValues) {
                                hidden.name = root.dataset.name || "";
                            }
                            hidden.value = value;
                            hidden.className = "admin-autocomplete__value";
                            root.appendChild(hidden);
                        });
                    }

                    function updateRequired() {
                        var isMissing = required && selectedValues.length === 0;
                        input.required = isMissing;
                        input.setCustomValidity(
                            isMissing ? "Select an option from the list." : ""
                        );
                    }

                    function renderSelected() {
                        if (!multiple || !selectedContainer) { return; }
                        selectedContainer.innerHTML = "";
                        selectedOptions().forEach(function (item) {
                            var chip = document.createElement("span");
                            chip.className = "admin-autocomplete__chip";
                            var label = document.createElement("span");
                            label.textContent = item.label;
                            var remove = document.createElement("button");
                            remove.type = "button";
                            remove.className = "admin-autocomplete__chip-remove";
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
                            empty.className = "admin-autocomplete__empty";
                            empty.textContent = isLoadingOptions ? "Loading…" : "No matches";
                            list.appendChild(empty);
                            active = -1;
                            return;
                        }
                        if (active >= matches.length) { active = matches.length - 1; }
                        matches.forEach(function (item, index) {
                            var option = document.createElement("li");
                            option.className = "admin-autocomplete__option" + (index === active ? " is-active" : "");
                            option.textContent = item.label;
                            option.dataset.value = item.value;
                            option.setAttribute("role", "option");
                            option.addEventListener("mousedown", function (event) {
                                event.preventDefault();
                                event.stopPropagation();
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
                            cacheSelectedOptions([item]);
                            input.value = "";
                            active = -1;
                            syncHiddenInputs();
                            renderSelected();
                            updateRequired();
                            if (status) { status.textContent = item.label + " selected."; }
                            root.dispatchEvent(new CustomEvent("admin-autocomplete-option-selected", { bubbles: true, detail: item }));
                            setOpen(true);
                            return;
                        }
                        input.value = item.label;
                        searchQueryOverride = null;
                        selectedValues = [item.value];
                        cacheSelectedOptions([item]);
                        syncHiddenInputs();
                        updateRequired();
                        if (status) { status.textContent = item.label + " selected."; }
                        root.dispatchEvent(new CustomEvent("admin-autocomplete-option-selected", { bubbles: true, detail: item }));
                        setOpen(false);
                    }

                    function removeSelected(value) {
                        selectedValues = selectedValues.filter(function (item) { return item !== value; });
                        remoteBaseOptions = null;
                        syncHiddenInputs();
                        renderSelected();
                        updateRequired();
                        var removed = selectedOptionCache.find(function (item) { return item.value === value; });
                        if (status && removed) { status.textContent = removed.label + " removed."; }
                    }

                    input.addEventListener("focus", function () {
                        setOpen(true);
                        if (sourceURL) {
                            searchQueryOverride = "";
                            fetchRemoteOptions(true);
                        }
                    });
                    input.addEventListener("input", function () {
                        searchQueryOverride = null;
                        if (!multiple) {
                            selectedValues = [];
                            syncHiddenInputs();
                            updateRequired();
                        }
                        active = 0;
                        setOpen(true);
                        if (sourceURL) { fetchRemoteOptions(); }
                    });
                    if (inputWrap && selectedContainer) {
                        selectedContainer.addEventListener("click", function (event) {
                            var target = event.target;
                            if (target && target.closest) {
                                var remove = target.closest(".admin-autocomplete__chip-remove");
                                if (remove) {
                                    event.preventDefault();
                                    event.stopPropagation();
                                    removeSelected(remove.dataset.value || "");
                                    setOpen(false);
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
                    root.addEventListener("admin-autocomplete-set-values", function (event) {
                        var values = event.detail && Array.isArray(event.detail.values)
                            ? event.detail.values
                            : [];
                        selectedValues = values.filter(function (value, index) {
                            return (sourceURL
                                || selectedOptionCache.some(function (item) { return item.value === value; })
                                || options.some(function (item) { return item.value === value; }))
                                && values.indexOf(value) === index;
                        });
                        if (!multiple) {
                            selectedValues = selectedValues.slice(0, 1);
                            var selected = selectedOptions()[0];
                            input.value = selected ? selected.label : "";
                        }
                        else {
                            input.value = "";
                        }
                        syncHiddenInputs();
                        renderSelected();
                        updateRequired();
                        active = -1;
                        searchQueryOverride = null;
                        setOpen(false);
                        fetchRemoteSelectedOptions();
                    });
                    document.addEventListener("mousedown", function (event) { if (!root.contains(event.target)) { setOpen(false); } });
                    if (!multiple && selectedValues.length) {
                        var selected = selectedOptions()[0];
                        input.value = selected ? selected.label : "";
                    }
                    renderSelected();
                    syncHiddenInputs();
                    updateRequired();
                    fetchRemoteSelectedOptions();
                }

                function initializeAll() { document.querySelectorAll(".admin-autocomplete").forEach(initialize); }
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
