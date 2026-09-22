import CSS
import FeatherContracts
import HTML
import SGML
import WebBuilders
import WebComponents

import struct HTML.Button

public struct NewAdminFormFieldDatePicker: Component {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: String?
        public var placeholder: String?
        public var error: String?
        public var help: String?
        public var id: String
        public var isRequired: Bool
        public var isDisabled: Bool

        public init(
            name: String,
            label: String,
            value: String? = nil,
            placeholder: String? = nil,
            error: String? = nil,
            help: String? = nil,
            id: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.placeholder = placeholder
            self.error = error
            self.help = help
            self.id = id ?? name
            self.isRequired = isRequired
            self.isDisabled = isDisabled
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any CSS.Selector] {
        let root = ".new-admin-date-picker"

        return [
            Custom(root) {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Position(.relative)
            },
            Custom("\(root) label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Custom("\(root) .new-admin-date-picker__display") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 11.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .new-admin-date-picker__display:focus") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom("\(root) .new-admin-date-picker__picker") {
                Position(.absolute)
                Top(100.percent)
                Left(0.px)
                Width(320.px)
                MaxWidth(100.percent)
                MarginTop(6.px)
                Padding(16.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                ZIndex(.number(20))
            },
            Custom("\(root) .new-admin-date-picker__header") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(8.px)
            },
            Custom("\(root) .new-admin-date-picker__header strong") {
                FontSize(0.95.rem)
                FontWeight(.number(600))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .new-admin-date-picker__header button") {
                Width(32.px)
                Height(32.px)
                Padding(0.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .new-admin-date-picker__header button:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            },
            Custom("\(root) .new-admin-date-picker__calendar") {
                Display(.grid)
                GridTemplateColumns(.repeat(7, .fraction(1.fr)))
                Gap(6.px)
                MarginTop(12.px)
            },
            Custom("\(root) .new-admin-date-picker__calendar span") {
                Height(32.px)
            },
            Custom("\(root) .new-admin-date-picker__calendar button") {
                Width(100.percent)
                Height(32.px)
                Padding(0.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .new-admin-date-picker__calendar button:hover") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            },
            Custom(
                "\(root) .new-admin-date-picker__calendar button[aria-selected=\"true\"]"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Link.default))
                Color(.variable(TokenKey.Colors.Selection.text))
                FontWeight(.number(600))
            },
            Custom("\(root) .new-admin-date-picker__time") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                MarginTop(16.px)
            },
            Custom("\(root) .new-admin-date-picker__time-label") {
                FontSize(0.95.rem)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom("\(root) .new-admin-date-picker__time input") {
                Width(68.px)
                Height(40.px)
                BoxSizing(.borderBox)
                Padding(vertical: 10.px, horizontal: 12.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(1.rem)
                LineHeight(1.2)
                TextAlign(.center)
            },
            Custom("\(root) .new-admin-date-picker__time input:focus") {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom("\(root) .new-admin-date-picker__actions") {
                Display(.flex)
                JustifyContent(.flexEnd)
                Gap(8.px)
                MarginTop(16.px)
            },
            Custom("\(root) .new-admin-date-picker__actions button") {
                Padding(vertical: 8.px, horizontal: 12.px)
                BorderRadius(8.px)
                Cursor(.pointer)
            },
            Custom("\(root) .new-admin-date-picker__today") {
                MarginRight(.auto)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Link.default)
                )
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom("\(root) .new-admin-date-picker__cancel") {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom("\(root) .new-admin-date-picker__apply") {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Accents.Primary.border)
                )
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            },
            Custom("\(root) .field-error") {
                Color(.variable(TokenKey.Colors.Palette.Red.text))
                FontSize(0.86.rem)
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
                displayInput()
            }

            Input()
                .type(.hidden)
                .id(state.id)
                .name(state.name)
                .if(state.value != nil) { $0.value(state.value) }

            picker()
            Script(script())

            if let help = state.help {
                Span(help)
                    .id(helpID)
                    .class("field-help")
            }
            if let error = state.error {
                Span(error)
                    .id(errorID)
                    .class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-date-picker")
    }

    private func displayInput() -> Input {
        var input = Input()
            .type(.text)
            .id(displayID)
            .if(state.value != nil) { $0.value(state.value) }
            .readOnly()
            .ariaLabel(state.label)
            .ariaHasPopup(.dialog)
            .ariaControls(pickerID)
            .ariaExpanded("false")
            .ariaInvalid(state.error == nil ? .false : .true)

        if let placeholder = state.placeholder {
            input = input.placeholder(placeholder)
        }

        if let describedBy {
            input = input.ariaDescribedBy(describedBy)
        }
        if state.error != nil {
            input = input.ariaErrorMessage(errorID)
        }
        if state.isDisabled {
            input = input.disabled()
        }
        return input.class("new-admin-date-picker__display")
    }

    private func picker() -> some FlowContent {
        Div {
            Div {
                Button("‹")
                    .type(.button)
                    .ariaLabel("Previous month")
                    .class("new-admin-date-picker__previous")
                Strong("Select date and time")
                Button("›")
                    .type(.button)
                    .ariaLabel("Next month")
                    .class("new-admin-date-picker__next")
            }
            .class("new-admin-date-picker__header")
            Div {}
                .class("new-admin-date-picker__calendar")
                .role("grid")
            Div {
                Span("Time:").class("new-admin-date-picker__time-label")
                Input()
                    .type(.number)
                    .id("\(state.id)-hour")
                    .ariaLabel("Hour")
                    .min(0)
                    .max(23)
                    .setAttribute(name: "step", value: "1")
                Span(":")
                    .class("new-admin-date-picker__time-separator")
                    .ariaHidden("true")
                Input()
                    .type(.number)
                    .id("\(state.id)-minute")
                    .ariaLabel("Minute")
                    .min(0)
                    .max(59)
                    .setAttribute(name: "step", value: "1")
            }
            .class("new-admin-date-picker__time")
            Div {
                Button("Today")
                    .type(.button)
                    .class("new-admin-date-picker__today")
                Button("Cancel")
                    .type(.button)
                    .class("new-admin-date-picker__cancel")
                Button("Apply")
                    .type(.button)
                    .class("new-admin-date-picker__apply")
            }
            .class("new-admin-date-picker__actions")
        }
        .id(pickerID)
        .class("new-admin-date-picker__picker")
        .role("dialog")
        .hidden()
    }

    private var displayID: String { "\(state.id)-display" }
    private var pickerID: String { "\(state.id)-picker" }
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
            const root = document.getElementById('\#(state.id)')?.closest('.new-admin-date-picker');
            if (!root || root.dataset.initialized === 'true') return;
            root.dataset.initialized = 'true';

            const display = root.querySelector('#\#(displayID)');
            const value = root.querySelector('#\#(state.id)');
            const picker = root.querySelector('#\#(pickerID)');
            const calendar = root.querySelector('.new-admin-date-picker__calendar');
            const header = root.querySelector('.new-admin-date-picker__header strong');
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
            root.querySelector('.new-admin-date-picker__previous').addEventListener('click', function () {
                month.setMonth(month.getMonth() - 1); render();
            });
            root.querySelector('.new-admin-date-picker__next').addEventListener('click', function () {
                month.setMonth(month.getMonth() + 1); render();
            });
            root.querySelector('.new-admin-date-picker__today').addEventListener('click', function () {
                draft = new Date();
                month = new Date(draft.getFullYear(), draft.getMonth(), 1);
                render();
            });
            root.querySelector('.new-admin-date-picker__cancel').addEventListener('click', function () {
                draft = committed ? new Date(committed) : new Date();
                month = new Date(draft.getFullYear(), draft.getMonth(), 1);
                close();
            });
            root.querySelector('.new-admin-date-picker__apply').addEventListener('click', function () {
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
