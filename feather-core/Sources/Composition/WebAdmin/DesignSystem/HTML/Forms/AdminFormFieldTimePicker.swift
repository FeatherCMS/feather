public import CSS
import FeatherModuleKit
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminFormFieldTimePicker: Component {
    public struct State: Sendable {
        public var name: String
        public var label: String
        /// A wall-clock time serialized as `HH:mm`.
        public var value: String?
        public var placeholder: String?
        public var error: String?
        public var help: String?
        /// Optional BCP 47 locale used for labels and the displayed time.
        public var locale: String?
        /// Accepted for API consistency; wall-clock times have no date or time zone.
        public var timeZone: String?
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
            locale: String? = nil,
            timeZone: String? = nil,
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
        []
    }

    public func html(context: inout BuilderContext) -> Section {
        context.build(
            AdminFormFieldTimePickerCore(
                state: .init(
                    name: state.name,
                    label: state.label,
                    value: state.value,
                    placeholder: state.placeholder,
                    error: state.error,
                    help: state.help,
                    locale: state.locale,
                    timeZone: state.timeZone,
                    id: state.id,
                    isRequired: state.isRequired,
                    isDisabled: state.isDisabled
                ),
                mode: .time
            )
        )
    }
}
