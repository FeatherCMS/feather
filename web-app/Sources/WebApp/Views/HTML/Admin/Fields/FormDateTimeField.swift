import HTML
import SGML
import CSS
import WebStandards

struct FormDateTimeField: Component, FlowContent {
    struct State {
        var name: String
        var label: String
        var value: String?
        var error: String?
        var help: String?
        var id: String
        var isRequired: Bool
        var isDisabled: Bool
        var wrapperClass: String?

        init(
            name: String,
            label: String,
            value: String? = nil,
            error: String? = nil,
            help: String? = nil,
            id: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            wrapperClass: String? = nil
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.error = error
            self.help = help
            self.id = id ?? name
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.wrapperClass = wrapperClass
        }
    }

    var state: State

    init(state: State) {
        self.state = state
    }

    init(
        name: String,
        label: String,
        value: String? = nil,
        error: String? = nil,
        help: String? = nil,
        id: String? = nil,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        wrapperClass: String? = nil
    ) {
        self.state = .init(
            name: name,
            label: label,
            value: value,
            error: error,
            help: help,
            id: id,
            isRequired: isRequired,
            isDisabled: isDisabled,
            wrapperClass: wrapperClass
        )
    }

    func selectors() -> [any Selector] {
        Class("field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Custom("label .field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Class("form-datetime-field") {
            Position(.relative)
        }
        Custom(".cms-form .form-datetime-field > label") {
            Display(.grid)
            Gap(6.px)
        }
        Custom(".cms-form .form-datetime-field__display") {
            Width(100.percent)
            Cursor(.pointer)
            Background(color: .variable("cms-white"))
            Color(.variable("cms-strong-font"))
        }
        Class("form-datetime-field__picker") {
            Position(.absolute)
            Top(100.percent)
            Left(0.px)
            Width(320.px)
            MaxWidth(100.percent)
            MarginTop(6.px)
            Padding(16.px)
            Background(color: .variable("cms-white"))
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(12.px)
            UnsafeRawProperty(name: "box-shadow", value: "var(--cms-shadow)")
            UnsafeRawProperty(name: "z-index", value: "10")
        }
        Class("form-datetime-field__header") {
            Display(.flex)
            AlignItems(.center)
            JustifyContent(.spaceBetween)
            Gap(8.px)
        }
        Custom(".form-datetime-field__header strong") {
            Color(.variable("cms-strong-font"))
            FontSize(0.95.rem)
            FontWeight(600)
        }
        Custom(".form-datetime-field__header button") {
            Width(32.px)
            Height(32.px)
            Padding(0.px)
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(8.px)
            Background(color: .variable("cms-gray-1"))
            Color(.variable("cms-strong-font"))
            Cursor(.pointer)
        }
        Custom(".form-datetime-field__header button:hover") {
            Background(color: .variable("cms-gray-2"))
        }
        Class("form-datetime-field__calendar") {
            Display(.grid)
            UnsafeRawProperty(
                name: "grid-template-columns",
                value: "repeat(7, minmax(0, 1fr))"
            )
            Gap(6.px)
            MarginTop(12.px)
        }
        Custom(".form-datetime-field__calendar span") {
            Height(32.px)
        }
        Custom(".form-datetime-field__calendar button") {
            Width(100.percent)
            Height(32.px)
            Padding(0.px)
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(8.px)
            Background(color: .variable("cms-white"))
            Color(.variable("cms-light-font"))
            Cursor(.pointer)
        }
        Custom(".form-datetime-field__calendar button:hover") {
            BorderColor(.variable("cms-primary-border"))
            Background(color: .variable("cms-gray-1"))
        }
        Custom(".form-datetime-field__calendar button[aria-selected=\"true\"]") {
            BorderColor(.variable("cms-primary-border"))
            Background(color: .variable("cms-primary"))
            Color(.variable("cms-white"))
            FontWeight(600)
        }
        Class("form-datetime-field__time") {
            Display(.flex)
            AlignItems(.center)
            Gap(8.px)
            MarginTop(16.px)
        }
        Custom(".form-datetime-field__time-label") {
            FontSize(0.95.rem)
            Color(.variable("cms-light-font"))
        }
        Custom(".form-datetime-field__time input") {
            Width(68.px)
            Height(40.px)
            BoxSizing(.borderBox)
            Padding(vertical: 10.px, horizontal: 12.px)
            Border(1.px, .solid, .variable("cms-gray-2"))
            BorderRadius(10.px)
            Background(color: .variable("cms-white"))
            Color(.variable("cms-strong-font"))
            FontSize(1.rem)
            LineHeight(1.2)
            TextAlign(.center)
        }
        Custom(".form-datetime-field__time input:focus") {
            BorderColor(.variable("cms-primary-border"))
            UnsafeRawProperty(name: "outline", value: "none")
        }
        Custom(".form-datetime-field__time input::-webkit-inner-spin-button") {
            UnsafeRawProperty(name: "-webkit-appearance", value: "none")
            Margin(0.px)
        }
        Custom(".form-datetime-field__time input::-webkit-outer-spin-button") {
            UnsafeRawProperty(name: "-webkit-appearance", value: "none")
            Margin(0.px)
        }
        Class("form-datetime-field__actions") {
            Display(.flex)
            JustifyContent(.flexEnd)
            Gap(8.px)
            MarginTop(16.px)
        }
        Custom(".form-datetime-field__actions button") {
            Padding(vertical: 8.px, horizontal: 12.px)
            BorderRadius(8.px)
            Cursor(.pointer)
        }
        Custom(".form-datetime-field__cancel") {
            Border(1.px, .solid, .variable("cms-gray-2"))
            Background(color: .variable("cms-white"))
            Color(.variable("cms-strong-font"))
        }
        Custom(".form-datetime-field__apply") {
            Border(1.px, .solid, .variable("cms-primary-border"))
            Background(color: .variable("cms-primary"))
            Color(.variable("cms-white"))
        }
    }

    func content() -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                displayInput()
            }

            Input()
                .type(.hidden)
                .id(state.id)
                .name(state.name)
                .value(state.value)

            picker()
            Script(script())

            if let help = state.help {
                Span(help).id(helpID).class("field-help")
            }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .class("form-datetime-field")
        .if(state.error != nil) { $0.class("has-error") }
        .if(state.wrapperClass != nil) {
            if let wrapperClass = state.wrapperClass {
                return $0.class(wrapperClass)
            }
            return $0
        }
    }

    private func displayInput() -> Input {
        var input = Input()
            .type(.text)
            .id(displayID)
            .value(state.value)
            .readOnly()
            .ariaHasPopup(.dialog)
            .ariaControls(pickerID)
            .ariaExpanded("false")

        if let describedBy {
            input = input.ariaDescribedBy(describedBy)
        }
        input = input.ariaInvalid(state.error == nil ? .false : .true)
        if state.error != nil {
            input = input.ariaErrorMessage(errorID)
        }
        if state.isDisabled {
            input = input.disabled()
        }
        return input
    }

    private func picker() -> some FlowContent {
        Div {
            Div {
                Button("‹").type(.button).ariaLabel("Previous month").class("form-datetime-field__previous")
                Strong("Select date and time")
                Button("›").type(.button).ariaLabel("Next month").class("form-datetime-field__next")
            }.class("form-datetime-field__header")
            Div {}.class("form-datetime-field__calendar").role("grid")
            Div {
                Span("Time:").class("form-datetime-field__time-label")
                Input()
                    .type(.number)
                    .id("\(state.id)-hour")
                    .ariaLabel("Hour")
                    .min(0)
                    .max(23)
                    .setAttribute(name: "step", value: "1")
                Span(":")
                    .class("form-datetime-field__time-separator")
                    .ariaHidden("true")
                Input()
                    .type(.number)
                    .id("\(state.id)-minute")
                    .ariaLabel("Minute")
                    .min(0)
                    .max(59)
                    .setAttribute(name: "step", value: "1")
            }.class("form-datetime-field__time")
            Div {
                Button("Cancel").type(.button).class("form-datetime-field__cancel")
                Button("Apply").type(.button).class("form-datetime-field__apply")
            }.class("form-datetime-field__actions")
        }
        .id(pickerID)
        .class("form-datetime-field__picker")
        .role("dialog")
        .hidden()
    }

    private func fieldLabel() -> some BasicTag {
        Span {
            InlineText(state.label)
            if !state.isRequired {
                Span(" (Optional)").class("field-label__optional")
            }
        }.class("field-label")
    }

    private var displayID: String { "\(state.id)-display" }
    private var pickerID: String { "\(state.id)-picker" }
    private var helpID: String { "\(state.id)-help" }
    private var errorID: String { "\(state.id)-error" }
    private var describedBy: String? {
        [state.help == nil ? nil : helpID, state.error == nil ? nil : errorID]
            .compactMap { $0 }.joined(separator: " ").nilIfEmpty
    }

    private func script() -> String {
        #"""
        (function () {
            const root = document.getElementById('\#(state.id)')?.closest('.form-datetime-field');
            if (!root || root.dataset.initialized === 'true') return;
            root.dataset.initialized = 'true';

            const display = root.querySelector('#\#(displayID)');
            const value = root.querySelector('#\#(state.id)');
            const picker = root.querySelector('#\#(pickerID)');
            const calendar = root.querySelector('.form-datetime-field__calendar');
            const header = root.querySelector('.form-datetime-field__header strong');
            const hour = root.querySelector('#\#(state.id)-hour');
            const minute = root.querySelector('#\#(state.id)-minute');
            let draft = value.value ? new Date(value.value) : new Date();
            let committed = value.value;
            let month = new Date(draft.getFullYear(), draft.getMonth(), 1);

            function pad(number) {
                return String(number).padStart(2, '0');
            }

            function iso(date) {
                return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' +
                    pad(date.getDate()) + 'T' + pad(date.getHours()) + ':' + pad(date.getMinutes());
            }

            function format(date) {
                return new Intl.DateTimeFormat(undefined, {
                    dateStyle: 'long', timeStyle: 'short'
                }).format(date);
            }

            function render() {
                const year = month.getFullYear();
                const currentMonth = month.getMonth();
                header.textContent = new Intl.DateTimeFormat(undefined, {
                    month: 'long', year: 'numeric'
                }).format(month);
                calendar.replaceChildren();
                const firstDay = new Date(year, currentMonth, 1).getDay();
                const offset = (firstDay + 6) % 7;
                const days = new Date(year, currentMonth + 1, 0).getDate();
                for (let index = 0; index < offset + days; index += 1) {
                    if (index < offset) {
                        calendar.append(document.createElement('span'));
                        continue;
                    }
                    const day = index - offset + 1;
                    const button = document.createElement('button');
                    const date = new Date(year, currentMonth, day, draft.getHours(), draft.getMinutes());
                    button.type = 'button';
                    button.textContent = String(day);
                    button.setAttribute('role', 'gridcell');
                    button.setAttribute('aria-selected', date.toDateString() === draft.toDateString() ? 'true' : 'false');
                    button.addEventListener('click', function (event) {
                        event.stopPropagation();
                        draft = date;
                        render();
                    });
                    calendar.append(button);
                }
                hour.value = pad(draft.getHours());
                minute.value = pad(draft.getMinutes());
            }

            function open() {
                picker.hidden = false;
                display.setAttribute('aria-expanded', 'true');
                render();
                hour.focus();
            }

            function close() {
                picker.hidden = true;
                display.setAttribute('aria-expanded', 'false');
            }

            display.addEventListener('click', open);
            root.querySelector('.form-datetime-field__previous').addEventListener('click', function () {
                month.setMonth(month.getMonth() - 1); render();
            });
            root.querySelector('.form-datetime-field__next').addEventListener('click', function () {
                month.setMonth(month.getMonth() + 1); render();
            });
            root.querySelector('.form-datetime-field__cancel').addEventListener('click', function () {
                draft = committed ? new Date(committed) : new Date();
                month = new Date(draft.getFullYear(), draft.getMonth(), 1);
                close();
            });
            root.querySelector('.form-datetime-field__apply').addEventListener('click', function () {
                const hourValue = Number(hour.value);
                const minuteValue = Number(minute.value);
                const validHour = Number.isInteger(hourValue) && hourValue >= 0 && hourValue <= 23;
                const validMinute = Number.isInteger(minuteValue) && minuteValue >= 0 && minuteValue <= 59;
                hour.setCustomValidity(validHour ? '' : 'Enter a valid hour between 0 and 23.');
                minute.setCustomValidity(validMinute ? '' : 'Enter valid minutes between 0 and 59.');
                hour.setAttribute('aria-invalid', validHour ? 'false' : 'true');
                minute.setAttribute('aria-invalid', validMinute ? 'false' : 'true');
                if (!validHour || !validMinute) {
                    (validHour ? minute : hour).focus();
                    (validHour ? minute : hour).reportValidity();
                    return;
                }
                draft.setHours(hourValue, minuteValue, 0, 0);
                committed = iso(draft);
                value.value = committed;
                display.value = format(draft);
                value.dispatchEvent(new Event('change', { bubbles: true }));
                close();
            });
            document.addEventListener('click', function (event) {
                if (!root.contains(event.target)) close();
            });
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape' && !picker.hidden) {
                    close(); display.focus();
                }
            });
            if (value.value) display.value = format(new Date(value.value));
        })();
        """#
    }
}
