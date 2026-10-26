public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminMonthPicker: Component {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: Int?
        public var error: String?
        public var help: String?
        public var isDisabled: Bool

        public init(
            name: String,
            label: String,
            value: Int? = nil,
            error: String? = nil,
            help: String? = nil,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.error = error
            self.help = help
            self.isDisabled = isDisabled
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func selectors() -> [any Selector] {
        AdminFormFieldSelect(
            state: .init(
                name: state.name,
                label: state.label,
                value: state.value.map(String.init),
                options: Self.options,
                error: state.error,
                help: state.help,
                isDisabled: state.isDisabled
            )
        )
        .selectors()
    }

    public func html(context: inout BuilderContext) -> Section {
        context.build(
            AdminFormFieldSelect(
                state: .init(
                    name: state.name,
                    label: state.label,
                    value: state.value.map(String.init),
                    options: Self.options,
                    error: state.error,
                    help: state.help,
                    isDisabled: state.isDisabled
                )
            )
        )
    }

    private static let options = [
        AdminFormFieldSelect.SelectOption(
            label: "Select month",
            value: ""
        ),
        AdminFormFieldSelect.SelectOption(label: "January", value: "1"),
        AdminFormFieldSelect.SelectOption(label: "February", value: "2"),
        AdminFormFieldSelect.SelectOption(label: "March", value: "3"),
        AdminFormFieldSelect.SelectOption(label: "April", value: "4"),
        AdminFormFieldSelect.SelectOption(label: "May", value: "5"),
        AdminFormFieldSelect.SelectOption(label: "June", value: "6"),
        AdminFormFieldSelect.SelectOption(label: "July", value: "7"),
        AdminFormFieldSelect.SelectOption(label: "August", value: "8"),
        AdminFormFieldSelect.SelectOption(label: "September", value: "9"),
        AdminFormFieldSelect.SelectOption(label: "October", value: "10"),
        AdminFormFieldSelect.SelectOption(label: "November", value: "11"),
        AdminFormFieldSelect.SelectOption(label: "December", value: "12"),
    ]
}
