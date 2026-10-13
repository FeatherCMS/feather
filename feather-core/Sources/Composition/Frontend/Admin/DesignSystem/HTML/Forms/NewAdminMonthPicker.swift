public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminMonthPicker: Component {
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
        NewAdminFormFieldSelect(
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
            NewAdminFormFieldSelect(
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
        NewAdminFormFieldSelect.SelectOption(
            label: "Select month",
            value: ""
        ),
        NewAdminFormFieldSelect.SelectOption(label: "January", value: "1"),
        NewAdminFormFieldSelect.SelectOption(label: "February", value: "2"),
        NewAdminFormFieldSelect.SelectOption(label: "March", value: "3"),
        NewAdminFormFieldSelect.SelectOption(label: "April", value: "4"),
        NewAdminFormFieldSelect.SelectOption(label: "May", value: "5"),
        NewAdminFormFieldSelect.SelectOption(label: "June", value: "6"),
        NewAdminFormFieldSelect.SelectOption(label: "July", value: "7"),
        NewAdminFormFieldSelect.SelectOption(label: "August", value: "8"),
        NewAdminFormFieldSelect.SelectOption(label: "September", value: "9"),
        NewAdminFormFieldSelect.SelectOption(label: "October", value: "10"),
        NewAdminFormFieldSelect.SelectOption(label: "November", value: "11"),
        NewAdminFormFieldSelect.SelectOption(label: "December", value: "12"),
    ]
}
