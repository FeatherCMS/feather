import CSS
import HTML
import SGML
import WebStandards

import class Foundation.JSONEncoder

struct AdminAutocompleteField: Component, FlowContent {

    enum SelectionMode: String, Codable, Sendable {
        case single
        case multiple
    }

    struct OptionState: Object {
        var label: String
        var value: String
        var isSelected: Bool
    }

    struct State: Object {
        var key: String
        var label: String
        var placeholder: String
        var options: [OptionState]
        var error: String?
        var selectionMode: SelectionMode
        var isEnabled: Bool
    }

    var state: State

    func selectors() -> [any Selector] {
        Class("multiselect__label") {
            Display(.block)
            MarginBottom(6.px)
            Color(.variable("cms-strong-font"))
            FontWeight(.number(600))
        }
        Class("multiselect__menu") {
            Position(.relative)
        }
        Class("multiselect__control") {
            MinHeight(48.px)
            Display(.grid)
            GridTemplateColumns(
                .tracks([.auto, .fraction(1.fr), .length(28.px)])
            )
            Gap(6.px)
            Padding(8.px)
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(10.px)
            Background(color: .color(.variable("cms-white")))
            UnsafeRawProperty(name: "align-items", value: "center")
        }
        Custom(".multiselect__control:focus-within") {
            BorderColor(.variable("cms-gray-3"))
            UnsafeRawProperty(
                name: "outline",
                value: "2px solid var(--cms-gray-5)"
            )
            UnsafeRawProperty(name: "outline-offset", value: "1px")
        }
        Class("multiselect__chips") {
            Display(.inlineFlex)
            FlexWrap(.wrap)
            AlignItems(.center)
            Gap(6.px)
            MinWidth(0.px)
        }
        Class("multiselect__chip") {
            Display(.inlineFlex)
            AlignItems(.center)
            BorderRadius(999.px)
            Background(color: .color(.variable("cms-gray-2")))
            Color(.variable("cms-strong-font"))
            FontSize(14.px)
            Overflow(.hidden)
        }
        Class("multiselect__chip-label") {
            Padding(top: 4.px, right: 8.px, bottom: 4.px, left: 10.px)
        }
        Class("multiselect__chip-remove") {
            Width(28.px)
            Height(28.px)
            Border(0.px)
            Background(color: .transparent)
            Cursor(.pointer)
            Color(.variable("cms-light-font"))
        }
        Custom(
            ".multiselect__chip-remove:hover, .multiselect__chip-remove:focus-visible"
        ) {
            Background(color: .color(.variable("cms-gray-3")))
            UnsafeRawProperty(name: "outline", value: "none")
        }
        Custom(".cms-form input.multiselect__input[type=\"text\"]") {
            Width(100.percent)
            MinWidth(0.px)
            Border(0.px)
            Background(color: .transparent)
            FontSize(15.px)
            Padding(0.px)
            MinHeight(0.px)
            UnsafeRawProperty(name: "outline", value: "none")
            UnsafeRawProperty(name: "box-shadow", value: "none")
            UnsafeRawProperty(name: "appearance", value: "none")
            UnsafeRawProperty(name: "-webkit-appearance", value: "none")
            BorderRadius(0.px)
        }
        Custom(
            ".cms-form input.multiselect__input[type=\"text\"]:focus, .cms-form input.multiselect__input[type=\"text\"]:focus-visible"
        ) {
            UnsafeRawProperty(name: "outline", value: "none")
            UnsafeRawProperty(name: "box-shadow", value: "none")
        }
        Class("multiselect__toggle") {
            Width(28.px)
            Height(28.px)
            Border(0.px)
            BorderRadius(8.px)
            Background(color: .transparent)
            Cursor(.pointer)
            Padding(0.px)
        }
        Custom(".multiselect__toggle:focus, .multiselect__toggle:focus-visible")
        {
            UnsafeRawProperty(name: "outline", value: "none")
            UnsafeRawProperty(name: "box-shadow", value: "none")
        }
        Class("multiselect__toggle:hover") {
            Background(color: .color(.variable("cms-gray-2")))
        }
        Class("multiselect__chevron") {
            Display(.inlineBlock)
            Width(9.px)
            Height(9.px)
            BorderRight(2.px, .solid, .variable("cms-light-font"))
            BorderBottom(2.px, .solid, .variable("cms-light-font"))
            UnsafeRawProperty(
                name: "transform",
                value: "translateY(-2px) rotate(45deg)"
            )
            UnsafeRawProperty(name: "transition", value: "transform 140ms ease")
        }
        Custom(".multiselect__control--open .multiselect__chevron") {
            UnsafeRawProperty(
                name: "transform",
                value: "translateY(2px) rotate(225deg)"
            )
        }
        Class("multiselect__dropdown") {
            Position(.absolute)
            UnsafeRawProperty(name: "top", value: "calc(100% - 1px)")
            Left(0.px)
            Right(0.px)
            ZIndex(.number(20))
            Display(.none)
            MarginTop(0.px)
            Padding(4.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(10.px)
            Background(color: .color(.variable("cms-white")))
            MaxHeight(240.px)
            Overflow(.auto)
            ListStyle(.none)
        }
        Custom(".cms-content ul.multiselect__dropdown") {
            Margin(top: 8.px, right: 0.px, bottom: 0.px, left: 0.px)
        }
        Class("multiselect__dropdown--open") {
            Display(.block)
        }
        Class("multiselect__option") {
            Display(.block)
            Padding(top: 8.px, right: 10.px, bottom: 8.px, left: 10.px)
            BorderRadius(8.px)
            Cursor(.pointer)
        }
        Custom(".multiselect__option:hover, .multiselect__option--active") {
            Background(color: .color(.variable("cms-gray-2")))
        }
        Class("multiselect__empty") {
            Display(.block)
            Padding(top: 8.px, right: 10.px, bottom: 8.px, left: 10.px)
            Color(.variable("cms-light-font"))
        }
        Class("multiselect__status") {
            Position(.absolute)
            UnsafeRawProperty(name: "inline-size", value: "1px")
            UnsafeRawProperty(name: "block-size", value: "1px")
            Overflow(.hidden)
            UnsafeRawProperty(name: "clip-path", value: "inset(50%)")
        }
    }

    func content() -> some BasicTag {
        let selectedOptions = state.options.filter(\.isSelected)

        return Section {
            if state.isEnabled {
                Div {
                    Label(state.label)
                        .class("multiselect__label")

                    Div {
                        Div {
                            Div {}
                                .class("multiselect__chips")

                            Input()
                                .type(.text)
                                .class("multiselect__input")
                                .setAttribute(
                                    name: "autocomplete",
                                    value: "off"
                                )
                                .setAttribute(
                                    name: "placeholder",
                                    value: state.placeholder
                                )
                                .setAttribute(
                                    name: "role",
                                    value: "combobox"
                                )
                                .setAttribute(
                                    name: "aria-autocomplete",
                                    value: "list"
                                )
                                .setAttribute(
                                    name: "aria-activedescendant",
                                    value: ""
                                )
                                .setAttribute(
                                    name: "aria-expanded",
                                    value: "false"
                                )
                                .setAttribute(
                                    name: "aria-haspopup",
                                    value: "listbox"
                                )
                            Button {
                                Span {}.class("multiselect__chevron")
                            }
                            .type(.button)
                            .class("multiselect__toggle")
                            .setAttribute(
                                name: "aria-label",
                                value: "Toggle options"
                            )
                            .setAttribute(
                                name: "aria-expanded",
                                value: "false"
                            )
                        }
                        .class("multiselect__control")

                        Ul {}.class("multiselect__dropdown")
                            .setAttribute(name: "role", value: "listbox")
                            .setAttribute(
                                name: "aria-label",
                                value: state.label
                            )
                    }
                    .class("multiselect__menu")

                    Div {
                        for option in selectedOptions {
                            Input()
                                .type(.hidden)
                                .name(state.key)
                                .value(option.value)
                        }
                    }
                    .class("multiselect__values")
                    .if(selectedOptions.isEmpty) { $0.hidden() }

                    Div {}
                        .class("multiselect__status")
                        .setAttribute(name: "role", value: "status")
                        .setAttribute(name: "aria-live", value: "polite")
                        .setAttribute(name: "aria-atomic", value: "true")

                    Script(encodeOptions(state.options))
                        .type("application/json")
                        .class("multiselect__options")
                }
                .class("multiselect")
                .setAttribute(name: "data-name", value: state.key)
                .setAttribute(
                    name: "data-mode",
                    value: state.selectionMode.rawValue
                )

                Script(script())
            }
            else {
                Label {
                    AdminFieldLabel(label: state.label, required: false)
                    Input()
                        .type(.text)
                        .class("text-input")
                        .value(
                            selectedOptions.map(\.label).joined(separator: ", ")
                        )
                        .setAttribute(name: "disabled", value: "")
                }
            }

            if let error = state.error {
                Span(error).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
    }

    private func encodeOptions(
        _ options: [OptionState]
    ) -> String {
        let payload = options.map {
            OptionPayload(
                id: $0.value,
                label: $0.label
            )
        }
        guard let data = try? JSONEncoder().encode(payload),
            let json = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return json
    }

    private func script() -> String {
        #"""
        (function () {
            if (window.__webAppAdminAutocompleteInitialized) {
                return;
            }
            window.__webAppAdminAutocompleteInitialized = true;

            var multiselectCounter = 0;

            function createMultiselect(root) {
                if (root.dataset.bound === "1") {
                    return;
                }
                root.dataset.bound = "1";

                var selectionMode = root.dataset.mode === "single" ? "single" : "multiple";
                var instanceId = "multiselect-" + (++multiselectCounter);
                var input = root.querySelector(".multiselect__input");
                var label = root.querySelector(".multiselect__label");
                var chipsContainer = root.querySelector(".multiselect__chips");
                var listbox = root.querySelector(".multiselect__dropdown");
                var control = root.querySelector(".multiselect__control");
                var toggleButton = root.querySelector(".multiselect__toggle");
                var statusRegion = root.querySelector(".multiselect__status");
                var valuesContainer = root.querySelector(".multiselect__values");
                var optionsSource = root.querySelector(".multiselect__options");

                if (!input || !chipsContainer || !listbox || !control || !toggleButton || !statusRegion || !valuesContainer || !optionsSource) {
                    return;
                }

                var state = {
                    allOptions: [],
                    selected: [],
                    query: "",
                    open: false,
                    highlightedIndex: -1
                };

                function setupAria() {
                    var inputId = instanceId + "-input";
                    var listboxId = instanceId + "-listbox";

                    input.id = input.id || inputId;
                    listbox.id = listbox.id || listboxId;

                    if (label) {
                        label.setAttribute("for", input.id);
                    }

                    control.setAttribute("aria-owns", listbox.id);
                    input.setAttribute("aria-controls", listbox.id);
                    toggleButton.setAttribute("aria-controls", listbox.id);
                }

                function loadOptions() {
                    try {
                        var payload = JSON.parse(optionsSource.textContent || "[]");
                        state.allOptions = payload.filter(function (item) {
                            return item && typeof item.id === "string" && typeof item.label === "string";
                        }).map(function (item) {
                            return { value: item.id, label: item.label };
                        });
                    } catch (_) {
                        state.allOptions = [];
                    }
                }

                function loadSelected() {
                    state.selected = Array.prototype.map.call(
                        valuesContainer.querySelectorAll('input[type="hidden"]'),
                        function (element) {
                            var value = element.value;
                            var match = state.allOptions.find(function (item) {
                                return item.value === value;
                            });
                            return match || { value: value, label: value };
                        }
                    );
                }

                function activateRoot() {
                    document.dispatchEvent(new CustomEvent(
                        "webapp:multiselect-activate",
                        { detail: { root: root } }
                    ));
                }

                function selectedValueSet() {
                    return new Set(state.selected.map(function (item) {
                        return item.value;
                    }));
                }

                function filteredOptions() {
                    var selectedSet = selectedValueSet();
                    var query = state.query.trim().toLowerCase();

                    return state.allOptions.filter(function (item) {
                        if (selectedSet.has(item.value)) {
                            return false;
                        }
                        if (!query) {
                            return true;
                        }
                        return item.label.toLowerCase().includes(query) || item.value.toLowerCase().includes(query);
                    });
                }

                function openDropdown() {
                    state.open = true;
                    if (state.highlightedIndex === -1 && filteredOptions().length > 0) {
                        state.highlightedIndex = 0;
                    }
                    listbox.classList.add("multiselect__dropdown--open");
                    control.classList.add("multiselect__control--open");
                    input.setAttribute("aria-expanded", "true");
                    toggleButton.setAttribute("aria-expanded", "true");
                }

                function closeDropdown() {
                    state.open = false;
                    state.highlightedIndex = -1;
                    input.setAttribute("aria-activedescendant", "");
                    listbox.classList.remove("multiselect__dropdown--open");
                    control.classList.remove("multiselect__control--open");
                    input.setAttribute("aria-expanded", "false");
                    toggleButton.setAttribute("aria-expanded", "false");
                }

                function announce(message) {
                    statusRegion.textContent = "";
                    requestAnimationFrame(function () {
                        statusRegion.textContent = message;
                    });
                }

                function renderChips() {
                    chipsContainer.innerHTML = "";

                    state.selected.forEach(function (item) {
                        var chip = document.createElement("span");
                        chip.className = "multiselect__chip";

                        var labelText = document.createElement("span");
                        labelText.className = "multiselect__chip-label";
                        labelText.textContent = item.label;

                        var remove = document.createElement("button");
                        remove.className = "multiselect__chip-remove";
                        remove.type = "button";
                        remove.dataset.value = item.value;
                        remove.setAttribute("aria-label", "Remove " + item.label);
                        remove.textContent = "×";

                        chip.append(labelText, remove);
                        chipsContainer.append(chip);
                    });
                }

                function renderHiddenInputs() {
                    var name = root.dataset.name;
                    valuesContainer.innerHTML = "";
                    valuesContainer.hidden = state.selected.length === 0;

                    if (!name) {
                        return;
                    }

                    state.selected.forEach(function (item) {
                        var hiddenInput = document.createElement("input");
                        hiddenInput.type = "hidden";
                        hiddenInput.name = name;
                        hiddenInput.value = item.value;
                        valuesContainer.append(hiddenInput);
                    });
                }

                function keepActiveOptionVisible() {
                    var activeOption = listbox.querySelector(".multiselect__option--active");
                    if (!activeOption) {
                        return;
                    }

                    var padding = 8;
                    var visibleTop = listbox.scrollTop + padding;
                    var visibleBottom = listbox.scrollTop + listbox.clientHeight - padding;
                    var optionTop = activeOption.offsetTop;
                    var optionBottom = optionTop + activeOption.offsetHeight;

                    if (optionTop < visibleTop) {
                        listbox.scrollTop = optionTop - padding;
                    } else if (optionBottom > visibleBottom) {
                        listbox.scrollTop = optionBottom - listbox.clientHeight + padding;
                    }
                }

                function renderDropdown() {
                    var options = filteredOptions();

                    if (!state.open) {
                        listbox.innerHTML = "";
                        return;
                    }

                    if (options.length === 0) {
                        state.highlightedIndex = -1;
                        input.setAttribute("aria-activedescendant", "");
                        listbox.innerHTML = '<li class="multiselect__empty">No matches</li>';
                        return;
                    }

                    if (state.highlightedIndex >= options.length) {
                        state.highlightedIndex = options.length - 1;
                    }

                    listbox.innerHTML = "";

                    options.forEach(function (item, index) {
                        var optionId = instanceId + "-option-" + item.value;
                        var li = document.createElement("li");
                        li.id = optionId;
                        li.className = "multiselect__option";
                        li.setAttribute("role", "option");
                        li.setAttribute("aria-selected", "false");
                        li.dataset.value = item.value;
                        li.dataset.index = String(index);
                        li.textContent = item.label;

                        if (index === state.highlightedIndex) {
                            li.classList.add("multiselect__option--active");
                            li.setAttribute("aria-selected", "true");
                            input.setAttribute("aria-activedescendant", optionId);
                        }

                        li.addEventListener("mousedown", function (event) {
                            event.preventDefault();
                            event.stopPropagation();
                            selectOptionByValue(item.value);
                        });

                        listbox.append(li);
                    });

                    if (state.highlightedIndex === -1) {
                        input.setAttribute("aria-activedescendant", "");
                        return;
                    }

                    keepActiveOptionVisible();
                }

                function render() {
                    renderChips();
                    renderHiddenInputs();
                    renderDropdown();
                }

                function addSelected(option) {
                    if (selectionMode === "single") {
                        state.selected = [option];
                    } else if (state.selected.some(function (item) { return item.value === option.value; })) {
                        return;
                    } else {
                        state.selected.push(option);
                    }

                    state.query = "";
                    input.value = "";
                    state.highlightedIndex = -1;

                    if (selectionMode === "single") {
                        closeDropdown();
                    } else {
                        openDropdown();
                    }

                    render();
                    announce(option.label + " selected.");
                }

                function removeSelected(value) {
                    var removed = state.selected.find(function (item) {
                        return item.value === value;
                    });
                    state.selected = state.selected.filter(function (item) {
                        return item.value !== value;
                    });
                    render();

                    if (removed) {
                        announce(removed.label + " removed.");
                    }
                }

                function highlight(index) {
                    state.highlightedIndex = index;
                    renderDropdown();
                }

                function moveHighlight(delta) {
                    var options = filteredOptions();
                    if (options.length === 0) {
                        state.highlightedIndex = -1;
                        renderDropdown();
                        return;
                    }

                    if (!state.open) {
                        openDropdown();
                    }

                    var nextIndex = state.highlightedIndex + delta;
                    if (nextIndex < 0) {
                        nextIndex = options.length - 1;
                    } else if (nextIndex >= options.length) {
                        nextIndex = 0;
                    }

                    highlight(nextIndex);
                }

                function selectHighlighted() {
                    var options = filteredOptions();
                    if (state.highlightedIndex < 0 || state.highlightedIndex >= options.length) {
                        return;
                    }
                    addSelected(options[state.highlightedIndex]);
                }

                function selectOptionByValue(value) {
                    var match = state.allOptions.find(function (item) {
                        return item.value === value;
                    });
                    if (!match) {
                        return;
                    }
                    addSelected(match);
                    input.focus();
                }

                input.addEventListener("focus", function () {
                    activateRoot();
                    openDropdown();
                    renderDropdown();
                });

                control.addEventListener("click", function (event) {
                    var target = event.target;
                    if (!(target instanceof HTMLElement)) {
                        return;
                    }
                    if (target.closest(".multiselect__chip-remove") || target.closest(".multiselect__toggle")) {
                        return;
                    }
                    activateRoot();
                    openDropdown();
                    renderDropdown();
                    input.focus();
                });

                input.addEventListener("input", function () {
                    state.query = input.value;
                    state.highlightedIndex = 0;
                    openDropdown();
                    renderDropdown();
                });

                input.addEventListener("keydown", function (event) {
                    switch (event.key) {
                    case "ArrowDown":
                        event.preventDefault();
                        moveHighlight(1);
                        break;
                    case "ArrowUp":
                        event.preventDefault();
                        moveHighlight(-1);
                        break;
                    case "Enter":
                        if (state.open) {
                            event.preventDefault();
                            selectHighlighted();
                        }
                        break;
                    case "Escape":
                        event.preventDefault();
                        closeDropdown();
                        renderDropdown();
                        break;
                    case "Tab":
                        closeDropdown();
                        renderDropdown();
                        break;
                    case "Backspace":
                        if (!input.value && state.selected.length > 0) {
                            removeSelected(
                                state.selected[state.selected.length - 1].value
                            );
                        }
                        break;
                    default:
                        break;
                    }
                });

                toggleButton.addEventListener("click", function () {
                    if (state.open) {
                        closeDropdown();
                        renderDropdown();
                    } else {
                        activateRoot();
                        openDropdown();
                        renderDropdown();
                        input.focus();
                    }
                });

                chipsContainer.addEventListener("click", function (event) {
                    var target = event.target;
                    if (!(target instanceof HTMLElement) || !target.classList.contains("multiselect__chip-remove")) {
                        return;
                    }
                    removeSelected(target.dataset.value || "");
                });

                listbox.addEventListener("mousedown", function (event) {
                    event.preventDefault();
                });

                listbox.addEventListener("click", function (event) {
                    event.stopPropagation();
                    var target = event.target;
                    if (!(target instanceof HTMLElement)) {
                        return;
                    }
                    var option = target.closest(".multiselect__option");
                    if (!(option instanceof HTMLElement)) {
                        return;
                    }
                    selectOptionByValue(option.dataset.value || "");
                });

                listbox.addEventListener("mousemove", function (event) {
                    var target = event.target;
                    if (!(target instanceof HTMLElement)) {
                        return;
                    }
                    var option = target.closest(".multiselect__option");
                    if (!(option instanceof HTMLElement)) {
                        return;
                    }
                    highlight(Number(option.dataset.index || "-1"));
                });

                root.addEventListener("focusout", function () {
                    setTimeout(function () {
                        var activeElement = document.activeElement;
                        if (activeElement instanceof Node && root.contains(activeElement)) {
                            return;
                        }
                        closeDropdown();
                        renderDropdown();
                    }, 0);
                });

                document.addEventListener("mousedown", function (event) {
                    if (!root.contains(event.target)) {
                        closeDropdown();
                        renderDropdown();
                    }
                });

                document.addEventListener("webapp:multiselect-activate", function (event) {
                    if (!event.detail || event.detail.root === root) {
                        return;
                    }
                    closeDropdown();
                    renderDropdown();
                    if (document.activeElement === input) {
                        input.blur();
                    }
                });

                setupAria();
                loadOptions();
                loadSelected();
                render();
            }

            function initAll() {
                document.querySelectorAll(".multiselect").forEach(createMultiselect);
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

private struct OptionPayload: Codable {
    let id: String
    let label: String
}
