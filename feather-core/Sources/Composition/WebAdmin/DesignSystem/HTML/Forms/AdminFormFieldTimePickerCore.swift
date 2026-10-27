import CSS
import FeatherModuleKit
import HTML
import SGML
import WebBuilders
import WebComponents

struct AdminFormFieldTimePickerCore: Component {
    enum Mode: String, Sendable {
        case date
        case time
        case dateTime
    }

    struct State: Sendable {
        var name: String
        var label: String
        var value: String?
        var placeholder: String?
        var error: String?
        var help: String?
        var locale: String?
        var timeZone: String?
        var yearRange: ClosedRange<Int>?
        var id: String
        var isRequired: Bool
        var isDisabled: Bool

        init(
            name: String,
            label: String,
            value: String? = nil,
            placeholder: String? = nil,
            error: String? = nil,
            help: String? = nil,
            locale: String? = nil,
            timeZone: String? = nil,
            yearRange: ClosedRange<Int>? = nil,
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
            self.locale = locale
            self.timeZone = timeZone
            self.yearRange = yearRange
            self.id = id ?? name
            self.isRequired = isRequired
            self.isDisabled = isDisabled
        }
    }

    let state: State
    let mode: Mode

    init(state: State, mode: Mode) {
        self.state = state
        self.mode = mode
    }

    func selectors() -> [any CSS.Selector] {
        let root = ".admin-date-picker"

        return [
            Custom(root) {
                Display(.flex)
                FlexDirection(.column)
                Gap(6.px)
                Position(.relative)
            },
            Custom("\(root) [hidden]") {
                Display(.none)
            },
            Custom("\(root)[data-mode=\"date\"] .admin-date-picker__time") {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root)[data-mode=\"date\"] .admin-date-picker__now") {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root)[data-mode=\"time\"] .admin-date-picker__header") {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root)[data-mode=\"time\"] .admin-date-picker__navigation")
            {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root)[data-mode=\"time\"] .admin-date-picker__weekdays") {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root)[data-mode=\"time\"] .admin-date-picker__calendar") {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root) label") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
            },
            Custom("\(root) .admin-date-picker__display") {
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
            Custom("\(root) .admin-date-picker__display:focus") {
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
            Custom("\(root) .admin-date-picker__picker") {
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
            Custom("\(root) .admin-date-picker__header") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(8.px)
            },
            Custom("\(root) .admin-date-picker__navigation") {
                Display(.grid)
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
                Gap(8.px)
                MinWidth(0.px)
                MarginTop(10.px)
            },
            Custom("\(root) .admin-date-picker__navigation select") {
                MinWidth(0.px)
                Width(100.percent)
                Height(38.px)
                Padding(vertical: 8.px, horizontal: 10.px)
                PaddingRight(30.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Cursor(.pointer)
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value: "calc(100% - 18px) 50%, calc(100% - 13px) 50%"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(name: "background-repeat", value: "no-repeat")
            },
            Custom(
                "\(root) .admin-date-picker__navigation select:focus-visible"
            ) {
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
            Custom(
                "\(root) .admin-date-picker__header button:not(.admin-date-picker__today)"
            ) {
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
            Custom(
                "\(root) .admin-date-picker__header button:hover:not(.admin-date-picker__today)"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            },
            Custom("\(root) .admin-date-picker__calendar") {
                Display(.grid)
                GridTemplateColumns(.repeat(7, .fraction(1.fr)))
                Gap(6.px)
                MarginTop(12.px)
            },
            Custom("\(root) .admin-date-picker__weekdays") {
                Display(.grid)
                GridTemplateColumns(.repeat(7, .fraction(1.fr)))
                Gap(6.px)
                MarginTop(12.px)
            },
            Custom("\(root) .admin-date-picker__weekdays span") {
                TextAlign(.center)
                FontSize(0.75.rem)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom("\(root) .admin-date-picker__calendar span") {
                Height(32.px)
            },
            Custom("\(root) .admin-date-picker__calendar button") {
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
            Custom("\(root) .admin-date-picker__calendar button:hover") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            },
            Custom(
                "\(root) .admin-date-picker__calendar button[aria-current=\"date\"]"
            ) {
                Outline(
                    1.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.default))
                )
                OutlineOffset((-2.0).px)
            },
            Custom(
                "\(root) .admin-date-picker__calendar button[aria-selected=\"true\"]"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Link.default))
                Color(.variable(TokenKey.Colors.Selection.text))
                FontWeight(.number(600))
            },
            Custom("\(root) .admin-date-picker__time") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.stretch)
                Gap(8.px)
                MarginTop(16.px)
            },
            Custom("\(root)[data-mode=\"time\"] .admin-date-picker__time") {
                MarginTop(0.px)
            },
            Custom("\(root) .admin-date-picker__time-controls") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(8.px)
            },
            Custom("\(root) .admin-date-picker__time-fields") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            },
            Custom("\(root) .admin-date-picker__time-entry") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            },
            Custom("\(root) .admin-date-picker__time-label") {
                FontSize(0.95.rem)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Custom(
                "\(root) .admin-date-picker__today, \(root) .admin-date-picker__now"
            ) {
                FontSize(0.84.rem)
            },
            Custom("\(root) .admin-date-picker__time input") {
                Width(44.px)
                Height(40.px)
                BoxSizing(.borderBox)
                UnsafeRawProperty(name: "appearance", value: "textfield")
                UnsafeRawProperty(name: "-moz-appearance", value: "textfield")
                Padding(vertical: 10.px, horizontal: 4.px)
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
            Custom(
                "\(root) .admin-date-picker__time input::-webkit-inner-spin-button, \(root) .admin-date-picker__time input::-webkit-outer-spin-button"
            ) {
                UnsafeRawProperty(name: "-webkit-appearance", value: "none")
                Margin(0.px)
            },
            Custom("\(root) .admin-date-picker__time input:focus") {
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
            Custom("\(root) .admin-date-picker__period") {
                Display(.inlineFlex)
                AlignItems(.stretch)
                Gap(2.px)
                Height(40.px)
                BoxSizing(.borderBox)
                Padding(3.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(10.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .admin-date-picker__period[hidden]") {
                UnsafeRawProperty(name: "display", value: "none !important")
            },
            Custom("\(root) .admin-date-picker__period button") {
                Border(0)
                BorderRadius(7.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Padding(vertical: 5.px, horizontal: 9.px)
                FontSize(0.84.rem)
                LineHeight(1.2)
                TextAlign(.center)
                Cursor(.pointer)
                WhiteSpace(.nowrap)
            },
            Custom(
                "\(root) .admin-date-picker__period button:hover:not(.active)"
            ) {
                Color(.variable(TokenKey.Colors.Link.hover))
                TextDecoration(.underline)
            },
            Custom("\(root) .admin-date-picker__period button.active") {
                Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                Color(.variable(TokenKey.Colors.Accents.Primary.text))
            },
            Custom("\(root) .admin-date-picker__actions") {
                Display(.flex)
                JustifyContent(.center)
                Gap(8.px)
                MarginTop(21.px)
            },
            Custom("\(root) .admin-date-picker__actions button") {
                Flex(1)
                Padding(vertical: 8.px, horizontal: 12.px)
                BorderRadius(8.px)
                Cursor(.pointer)
            },
            Custom("\(root) .admin-date-picker__cancel") {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom("\(root) .admin-date-picker__apply") {
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

    func html(context: inout BuilderContext) -> Section {
        Section {
            Label {
                context.build(
                    AdminFormFieldLabel(
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
                context.build(AdminFormFieldHelp(help, id: helpID))
            }
            if let error = state.error {
                Span(error)
                    .id(errorID)
                    .class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("admin-date-picker")
        .setAttribute(name: "data-mode", value: mode.rawValue)
        .setAttribute(name: "data-locale", value: state.locale ?? "")
        .setAttribute(name: "data-time-zone", value: state.timeZone ?? "")
        .setAttribute(
            name: "data-min-year",
            value: state.yearRange.map { String($0.lowerBound) } ?? ""
        )
        .setAttribute(
            name: "data-max-year",
            value: state.yearRange.map { String($0.upperBound) } ?? ""
        )
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
        return input.class("admin-date-picker__display")
    }

    private func picker() -> some FlowContent {
        Div {
            Div {
                Button("‹")
                    .type(.button)
                    .ariaLabel("Previous month")
                    .class("admin-date-picker__previous")
                Button("Today")
                    .type(.button)
                    .class("button secondary-ghost admin-date-picker__today")
                    .if(mode == .time) { $0.hidden() }
                Button("›")
                    .type(.button)
                    .ariaLabel("Next month")
                    .class("admin-date-picker__next")
            }
            .class("admin-date-picker__header")
            .if(mode == .time) { $0.hidden() }
            Div {}
                .class("admin-date-picker__navigation")
                .if(mode == .time) { $0.hidden() }
            Div {}
                .class("admin-date-picker__weekdays")
                .role("row")
                .if(mode == .time) { $0.hidden() }
            Div {}
                .class("admin-date-picker__calendar")
                .role("grid")
                .if(mode == .time) { $0.hidden() }
            Div {
                Span("Time:")
                    .class("admin-date-picker__time-label")
                    .if(mode == .time) { $0.hidden() }
                Div {
                    Div {
                        Div {
                            Input()
                                .type(.number)
                                .id("\(state.id)-hour")
                                .ariaLabel("Hour")
                                .min(0)
                                .max(23)
                                .setAttribute(name: "step", value: "1")
                            Span(":")
                                .class("admin-date-picker__time-separator")
                                .ariaHidden("true")
                            Input()
                                .type(.number)
                                .id("\(state.id)-minute")
                                .ariaLabel("Minute")
                                .min(0)
                                .max(59)
                                .setAttribute(name: "step", value: "1")
                        }
                        .class("admin-date-picker__time-fields")
                        .role("group")
                        .ariaLabel("Time")
                        Div {
                            Button("AM")
                                .type(.button)
                                .class("active")
                                .setAttribute(name: "data-period", value: "AM")
                                .setAttribute(
                                    name: "aria-pressed",
                                    value: "true"
                                )
                            Button("PM")
                                .type(.button)
                                .setAttribute(name: "data-period", value: "PM")
                                .setAttribute(
                                    name: "aria-pressed",
                                    value: "false"
                                )
                        }
                        .id("\(state.id)-period")
                        .role("group")
                        .ariaLabel("AM or PM")
                        .class("admin-date-picker__period")
                    }
                    .class("admin-date-picker__time-entry")
                    Button("Now")
                        .type(.button)
                        .class("button secondary-ghost admin-date-picker__now")
                        .if(mode == .date) { $0.hidden() }
                }
                .class("admin-date-picker__time-controls")
            }
            .class("admin-date-picker__time")
            .if(mode == .date) { $0.hidden() }
            Div {
                Button("Apply")
                    .type(.button)
                    .class("admin-date-picker__apply")
                Button("Cancel")
                    .type(.button)
                    .class("admin-date-picker__cancel")
            }
            .class("admin-date-picker__actions")
        }
        .id(pickerID)
        .class("admin-date-picker__picker")
        .role("dialog")
        .ariaLabel(
            mode == .date
                ? "Choose a date"
                : mode == .time ? "Choose a time" : "Choose a date and time"
        )
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
            const root = document.getElementById('\#(state.id)')?.closest('.admin-date-picker');
            if (!root || root.dataset.initialized === 'true') return;
            root.dataset.initialized = 'true';

            const mode = root.dataset.mode;
            const locale = root.dataset.locale || undefined;
            const requestedTimeZone = root.dataset.timeZone || undefined;
            const timeZone = mode === 'dateTime' ? requestedTimeZone : undefined;
            const configuredMinYear = Number(root.dataset.minYear);
            const configuredMaxYear = Number(root.dataset.maxYear);
            const minYear = Number.isInteger(configuredMinYear) && configuredMinYear > 0
                ? configuredMinYear : 1900;
            const maxYear = Number.isInteger(configuredMaxYear) && configuredMaxYear > 0
                ? configuredMaxYear : readCurrentYear();
            const display = root.querySelector('#\#(displayID)');
            const value = root.querySelector('#\#(state.id)');
            const picker = root.querySelector('#\#(pickerID)');
            const calendar = root.querySelector('.admin-date-picker__calendar');
            const weekdays = root.querySelector('.admin-date-picker__weekdays');
            const calendarHeader = root.querySelector('.admin-date-picker__header');
            const navigation = root.querySelector('.admin-date-picker__navigation');
            const hour = root.querySelector('#\#(state.id)-hour');
            const minute = root.querySelector('#\#(state.id)-minute');
            const period = root.querySelector('.admin-date-picker__period');
            const todayButton = root.querySelector('.admin-date-picker__today');
            const nowButton = root.querySelector('.admin-date-picker__now');
            const previousButton = root.querySelector('.admin-date-picker__previous');
            const nextButton = root.querySelector('.admin-date-picker__next');
            let committed = value.value || '';
            let selectedPeriod = 'AM';

            function readCurrentYear() {
                return readParts(new Date()).year;
            }

            function localeFormatter(options) {
                try {
                    return new Intl.DateTimeFormat(locale, {
                        calendar: 'gregory',
                        ...options
                    });
                } catch (_) {
                    return new Intl.DateTimeFormat(undefined, {
                        calendar: 'gregory',
                        ...options
                    });
                }
            }

            function formatter(options) {
                try {
                    return new Intl.DateTimeFormat(locale, {
                        calendar: 'gregory',
                        ...options,
                        ...(timeZone ? { timeZone } : {})
                    });
                } catch (_) {
                    return new Intl.DateTimeFormat(undefined, {
                        calendar: 'gregory',
                        ...options
                    });
                }
            }

            const preferredHourCycle = localeFormatter({ hour: 'numeric' })
                .resolvedOptions().hourCycle;
            const supportsTwelveHourClock =
                preferredHourCycle === 'h11' || preferredHourCycle === 'h12';
            const isTwelveHourClock = supportsTwelveHourClock;

            function pad(number) {
                return String(number).padStart(2, '0');
            }

            function setTimeInputs(hourValue, minuteValue) {
                const displayedHour = isTwelveHourClock
                    ? ((hourValue + 11) % 12) + 1
                    : hourValue;
                hour.min = isTwelveHourClock ? '1' : '0';
                hour.max = isTwelveHourClock ? '12' : '23';
                hour.value = pad(displayedHour);
                minute.value = pad(minuteValue);
                selectedPeriod = hourValue >= 12 ? 'PM' : 'AM';
                period.querySelectorAll('button').forEach(function (button) {
                    const isSelected = button.dataset.period === selectedPeriod;
                    button.classList.toggle('active', isSelected);
                    button.setAttribute('aria-pressed', isSelected ? 'true' : 'false');
                });
                period.hidden = !isTwelveHourClock;
            }

            function readParts(date) {
                if (!timeZone) {
                    return {
                        year: date.getFullYear(), month: date.getMonth() + 1,
                        day: date.getDate(), hour: date.getHours(), minute: date.getMinutes()
                    };
                }
                const parts = formatter({
                    year: 'numeric', month: '2-digit', day: '2-digit',
                    hour: '2-digit', minute: '2-digit', hourCycle: 'h23'
                }).formatToParts(date);
                const result = {};
                for (const part of parts) {
                    if (part.type !== 'literal') result[part.type] = Number(part.value);
                }
                return {
                    year: result.year, month: result.month, day: result.day,
                    hour: result.hour, minute: result.minute
                };
            }

            function writeParts(parts) {
                if (!timeZone) {
                    return new Date(parts.year, parts.month - 1, parts.day, parts.hour, parts.minute);
                }
                let candidate = Date.UTC(
                    parts.year, parts.month - 1, parts.day, parts.hour, parts.minute
                );
                for (let attempt = 0; attempt < 4; attempt += 1) {
                    const actual = readParts(new Date(candidate));
                    const wantedAsUTC = Date.UTC(
                        parts.year, parts.month - 1, parts.day, parts.hour, parts.minute
                    );
                    const actualAsUTC = Date.UTC(
                        actual.year, actual.month - 1, actual.day, actual.hour, actual.minute
                    );
                    const difference = wantedAsUTC - actualAsUTC;
                    if (difference === 0) break;
                    candidate += difference;
                }
                return new Date(candidate);
            }

            function parseValue(raw) {
                if (mode === 'date' && /^\d{4}-\d{2}-\d{2}$/.test(raw)) {
                    const [year, month, day] = raw.split('-').map(Number);
                    return new Date(year, month - 1, day, 12, 0);
                }
                if (mode === 'time' && /^\d{2}:\d{2}$/.test(raw)) {
                    const [hourValue, minuteValue] = raw.split(':').map(Number);
                    const date = new Date();
                    date.setHours(hourValue, minuteValue, 0, 0);
                    return date;
                }
                if (mode === 'dateTime' && raw) {
                    const parsed = new Date(raw);
                    if (!Number.isNaN(parsed.getTime())) return parsed;
                }
                return new Date();
            }

            let draft = parseValue(committed);
            let parts = readParts(draft);
            let viewYear = parts.year;
            let viewMonth = parts.month;
            let monthSelect;
            let yearSelect;

            function format(date) {
                if (mode === 'date') {
                    return formatter({ dateStyle: 'long' }).format(date);
                }
                if (mode === 'time') {
                    const shown = new Date(2000, 0, 1, date.getHours(), date.getMinutes());
                    return localeFormatter({
                        hour: 'numeric', minute: '2-digit',
                        hourCycle: isTwelveHourClock ? 'h12' : 'h23'
                    }).format(shown);
                }
                return formatter({
                    dateStyle: 'long', timeStyle: 'short',
                    hourCycle: isTwelveHourClock ? 'h12' : 'h23'
                }).format(date);
            }

            function formatTime(hourValue, minuteValue) {
                const shown = new Date(2000, 0, 1, hourValue, minuteValue);
                return localeFormatter({
                    hour: 'numeric', minute: '2-digit',
                    hourCycle: isTwelveHourClock ? 'h12' : 'h23'
                }).format(shown);
            }

            function createNavigation() {
                if (monthSelect) return;
                monthSelect = document.createElement('select');
                monthSelect.setAttribute('aria-label', 'Month');
                yearSelect = document.createElement('select');
                yearSelect.setAttribute('aria-label', 'Year');
                const monthFormatter = localeFormatter({
                    month: 'long', timeZone: 'UTC'
                });
                for (let monthIndex = 0; monthIndex < 12; monthIndex += 1) {
                    const option = document.createElement('option');
                    option.value = String(monthIndex + 1);
                    option.textContent = monthFormatter.format(new Date(Date.UTC(2020, monthIndex, 1)));
                    monthSelect.append(option);
                }
                for (let year = maxYear; year >= minYear; year -= 1) {
                    const option = document.createElement('option');
                    option.value = String(year);
                    option.textContent = String(year);
                    yearSelect.append(option);
                }
                monthSelect.addEventListener('change', function () {
                    viewMonth = Number(monthSelect.value);
                    render();
                });
                yearSelect.addEventListener('change', function () {
                    viewYear = Number(yearSelect.value);
                    render();
                });
                navigation.replaceChildren(yearSelect, monthSelect);
            }

            function firstWeekday() {
                try {
                    const currentLocale = new Intl.Locale(locale || navigator.language);
                    const weekInfo = currentLocale.weekInfo || currentLocale.getWeekInfo?.();
                    return weekInfo ? weekInfo.firstDay % 7 : 1;
                } catch (_) {
                    return 1;
                }
            }

            function renderWeekdays() {
                weekdays.replaceChildren();
                const weekdayFormatter = localeFormatter({
                    weekday: 'short', timeZone: 'UTC'
                });
                const weekStartsOn = firstWeekday();
                const firstDate = ((weekStartsOn + 6) % 7) + 1;
                for (let index = 0; index < 7; index += 1) {
                    const label = document.createElement('span');
                    label.textContent = weekdayFormatter.format(
                        new Date(Date.UTC(2024, 0, firstDate + index))
                    );
                    label.setAttribute('role', 'columnheader');
                    weekdays.append(label);
                }
            }

            function render() {
                const dateMode = mode !== 'time';
                calendarHeader.hidden = !dateMode;
                navigation.hidden = !dateMode;
                weekdays.hidden = !dateMode;
                calendar.hidden = !dateMode;
                root.querySelector('.admin-date-picker__time').hidden = mode === 'date';
                const currentYear = readParts(new Date()).year;
                todayButton.hidden = mode === 'time';
                nowButton.hidden = mode === 'date';
                todayButton.disabled = mode !== 'time' &&
                    (currentYear < minYear || currentYear > maxYear);
                nowButton.disabled = mode !== 'time' &&
                    (currentYear < minYear || currentYear > maxYear);
                const selected = readParts(draft);

                if (dateMode) {
                    const monthStart = new Date(viewYear, viewMonth - 1, 1);
                    const firstDay = monthStart.getDay();
                    const offset = (firstDay - firstWeekday() + 7) % 7;
                    const days = new Date(viewYear, viewMonth, 0).getDate();
                    previousButton.disabled = viewYear <= minYear && viewMonth === 1;
                    nextButton.disabled = viewYear >= maxYear && viewMonth === 12;
                    calendar.replaceChildren();
                    renderWeekdays();
                    for (let index = 0; index < offset + days; index += 1) {
                        if (index < offset) {
                            calendar.append(document.createElement('span'));
                            continue;
                        }
                        const day = index - offset + 1;
                        const button = document.createElement('button');
                        const candidate = mode === 'date'
                            ? new Date(viewYear, viewMonth - 1, day, 12, 0)
                            : writeParts({
                                year: viewYear, month: viewMonth, day,
                                hour: selected.hour, minute: selected.minute
                            });
                        const candidateParts = readParts(candidate);
                        const isSelected = candidateParts.year === selected.year &&
                            candidateParts.month === selected.month && candidateParts.day === selected.day;
                        const today = readParts(new Date());
                        button.type = 'button';
                        button.textContent = String(day);
                        button.setAttribute('role', 'gridcell');
                        button.setAttribute('aria-selected', isSelected ? 'true' : 'false');
                        if (candidateParts.year === today.year && candidateParts.month === today.month && candidateParts.day === today.day) {
                            button.setAttribute('aria-current', 'date');
                        }
                        button.setAttribute('aria-label', formatter({ dateStyle: 'full' }).format(candidate));
                        button.addEventListener('click', function (event) {
                            event.stopPropagation();
                            if (mode === 'date') {
                                draft = candidate;
                            } else {
                                draft = writeParts({
                                    year: viewYear, month: viewMonth, day,
                                    hour: selected.hour, minute: selected.minute
                                });
                            }
                            parts = readParts(draft);
                            render();
                            calendar.querySelector('[aria-selected="true"]')?.focus();
                        });
                        calendar.append(button);
                    }
                    if (monthSelect && yearSelect) {
                        monthSelect.value = String(viewMonth);
                        yearSelect.value = String(viewYear);
                    }
                }

                const timeParts = mode === 'dateTime' ? selected : readParts(draft);
                setTimeInputs(timeParts.hour, timeParts.minute);
            }

            function positionPicker() {
                if (picker.hidden) return;
                const bounds = root.getBoundingClientRect();
                const availableWidth = Math.max(180, window.innerWidth - 24);
                const pickerWidth = Math.min(320, availableWidth);
                const availableBelow = window.innerHeight - bounds.bottom;
                const availableAbove = bounds.top;
                const placeAbove = availableBelow < picker.offsetHeight + 12 &&
                    availableAbove > availableBelow;
                picker.style.width = pickerWidth + 'px';
                picker.style.maxHeight = Math.max(160, window.innerHeight - 24) + 'px';
                picker.style.overflowY = 'auto';
                picker.style.top = placeAbove ? 'auto' : '100%';
                picker.style.bottom = placeAbove ? '100%' : 'auto';
                picker.style.marginTop = placeAbove ? '0' : '6px';
                picker.style.marginBottom = placeAbove ? '6px' : '0';
                const alignRight = bounds.left + pickerWidth > window.innerWidth - 12;
                picker.style.left = alignRight ? 'auto' : '0';
                picker.style.right = alignRight ? '0' : 'auto';
            }

            calendar.addEventListener('keydown', function (event) {
                const keys = {
                    ArrowLeft: -1,
                    ArrowRight: 1,
                    ArrowUp: -7,
                    ArrowDown: 7
                };
                const offset = keys[event.key];
                if (offset === undefined) return;
                const days = Array.from(calendar.querySelectorAll('button[role="gridcell"]'));
                const currentIndex = days.indexOf(document.activeElement);
                const next = days[currentIndex + offset];
                if (!next) return;
                event.preventDefault();
                next.focus();
            });

            function open() {
                draft = parseValue(committed);
                parts = readParts(draft);
                viewYear = parts.year;
                viewMonth = parts.month;
                picker.hidden = false;
                display.setAttribute('aria-expanded', 'true');
                render();
                positionPicker();
                if (mode === 'time') {
                    hour.focus();
                } else {
                    calendar.querySelector('[aria-selected="true"]')?.focus();
                }
            }

            function close(restoreDraft) {
                if (restoreDraft) {
                    draft = parseValue(committed);
                    parts = readParts(draft);
                }
                picker.hidden = true;
                display.setAttribute('aria-expanded', 'false');
            }

            function commit(raw) {
                committed = raw;
                value.value = raw;
                if (mode === 'time') {
                    const [hourValue, minuteValue] = raw.split(':').map(Number);
                    display.value = formatTime(hourValue, minuteValue);
                } else {
                    display.value = format(draft);
                }
                value.dispatchEvent(new Event('change', { bubbles: true }));
                close(false);
                display.focus();
            }

            display.addEventListener('click', function () {
                if (picker.hidden) open();
                else close(true);
            });
            display.addEventListener('keydown', function (event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    if (picker.hidden) open();
                    else close(true);
                }
            });
            previousButton.addEventListener('click', function () {
                if (viewYear <= minYear && viewMonth === 1) return;
                viewMonth -= 1;
                if (viewMonth < 1) { viewMonth = 12; viewYear -= 1; }
                render();
            });
            nextButton.addEventListener('click', function () {
                if (viewYear >= maxYear && viewMonth === 12) return;
                viewMonth += 1;
                if (viewMonth > 12) { viewMonth = 1; viewYear += 1; }
                render();
            });
            todayButton.addEventListener('click', function () {
                const now = new Date();
                const currentYear = readParts(now).year;
                if (currentYear < minYear || currentYear > maxYear) return;
                const today = readParts(now);
                if (mode === 'date') {
                    draft = new Date(today.year, today.month - 1, today.day, 12, 0);
                } else {
                    const selected = readParts(draft);
                    draft = writeParts({
                        year: today.year, month: today.month, day: today.day,
                        hour: selected.hour, minute: selected.minute
                    });
                }
                parts = readParts(draft);
                viewYear = parts.year;
                viewMonth = parts.month;
                render();
                calendar.querySelector('[aria-selected="true"]')?.focus();
            });
            nowButton.addEventListener('click', function () {
                const now = new Date();
                const currentYear = readParts(now).year;
                if (mode === 'dateTime' &&
                    (currentYear < minYear || currentYear > maxYear)) return;
                if (mode === 'time') {
                    draft = now;
                    setTimeInputs(now.getHours(), now.getMinutes());
                } else {
                    draft = now;
                    parts = readParts(draft);
                    viewYear = parts.year;
                    viewMonth = parts.month;
                    setTimeInputs(parts.hour, parts.minute);
                }
                render();
                if (mode === 'time') hour.focus();
                else calendar.querySelector('[aria-selected="true"]')?.focus();
            });
            period.addEventListener('click', function (event) {
                const button = event.target.closest('button[data-period]');
                if (!button) return;
                selectedPeriod = button.dataset.period === 'PM' ? 'PM' : 'AM';
                period.querySelectorAll('button').forEach(function (periodButton) {
                    const isSelected = periodButton === button;
                    periodButton.classList.toggle('active', isSelected);
                    periodButton.setAttribute('aria-pressed', isSelected ? 'true' : 'false');
                });
            });
            root.querySelector('.admin-date-picker__cancel').addEventListener('click', function () {
                close(true);
                display.focus();
            });
            root.querySelector('.admin-date-picker__apply').addEventListener('click', function () {
                const enteredHour = mode === 'date' ? 0 : Number(hour.value);
                const minuteValue = mode === 'date' ? 0 : Number(minute.value);
                const minimumHour = isTwelveHourClock ? 1 : 0;
                const maximumHour = isTwelveHourClock ? 12 : 23;
                const validHour = mode === 'date' || (
                    Number.isInteger(enteredHour) &&
                    enteredHour >= minimumHour && enteredHour <= maximumHour
                );
                const validMinute = Number.isInteger(minuteValue) && minuteValue >= 0 && minuteValue <= 59;
                if (mode !== 'date') {
                    hour.setCustomValidity(validHour ? '' : isTwelveHourClock
                        ? 'Enter a valid hour between 1 and 12.'
                        : 'Enter a valid hour between 0 and 23.');
                    minute.setCustomValidity(validMinute ? '' : 'Enter valid minutes between 0 and 59.');
                    hour.setAttribute('aria-invalid', validHour ? 'false' : 'true');
                    minute.setAttribute('aria-invalid', validMinute ? 'false' : 'true');
                    if (!validHour || !validMinute) {
                        (validHour ? minute : hour).focus();
                        (validHour ? minute : hour).reportValidity();
                        return;
                    }
                }
                const hourValue = mode === 'date' ? 0 : isTwelveHourClock
                    ? (enteredHour % 12) + (selectedPeriod === 'PM' ? 12 : 0)
                    : enteredHour;
                if (mode === 'time') {
                    commit(pad(hourValue) + ':' + pad(minuteValue));
                    return;
                }
                if (mode === 'date') {
                    const selected = readParts(draft);
                    commit(selected.year + '-' + pad(selected.month) + '-' + pad(selected.day));
                    return;
                }
                draft = writeParts({
                    year: parts.year, month: parts.month, day: parts.day,
                    hour: hourValue, minute: minuteValue
                });
                parts = readParts(draft);
                commit(draft.toISOString());
            });
            document.addEventListener('click', function (event) {
                if (!picker.hidden && !root.contains(event.target)) close(true);
            });
            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape' && !picker.hidden) {
                    close(true);
                    display.focus();
                }
            });
            window.addEventListener('resize', positionPicker);
            document.addEventListener('scroll', positionPicker, true);
            createNavigation();
            render();
            if (committed) {
                display.value = mode === 'time'
                    ? formatTime(Number(committed.slice(0, 2)), Number(committed.slice(3, 5)))
                    : format(draft);
            }
        })();
        """#
    }
}
