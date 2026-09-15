import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

/// A select-based form field for the account pagination limit.
public struct NewAdminFormFieldPaginationLimit: Component {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: String?
        public var error: String?
        public var isRequired: Bool
        public var isDisabled: Bool

        public init(
            name: String,
            label: String,
            value: String? = nil,
            error: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
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
        []
    }

    public func html(context: inout BuilderContext) -> Section {
        context.build(
            NewAdminFormFieldSelect(
                state: .init(
                    name: state.name,
                    label: state.label,
                    value: state.value,
                    options: Self.options,
                    error: state.error,
                    isRequired: state.isRequired,
                    isDisabled: state.isDisabled
                )
            )
        )
    }

    public static let options: [NewAdminFormFieldSelect.SelectOption] = [
        .init(label: "10", value: "10"),
        .init(label: "20", value: "20"),
        .init(label: "50", value: "50"),
        .init(label: "100", value: "100"),
    ]
}
