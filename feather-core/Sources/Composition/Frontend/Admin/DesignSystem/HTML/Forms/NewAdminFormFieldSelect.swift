import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminFormFieldSelect: Component {
    public struct SelectOption: Sendable {
        public let label: String
        public let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }

    public struct State: Sendable {
        public var name: String
        public var label: String
        public var value: String?
        public var options: [SelectOption]
        public var error: String?
        public var isRequired: Bool

        public init(
            name: String,
            label: String,
            value: String? = nil,
            options: [SelectOption],
            error: String? = nil,
            isRequired: Bool = false
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.options = options
            self.error = error
            self.isRequired = isRequired
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func html(context: inout RenderContext) -> Section {
        let errorID = "\(state.name)-error"
        return Section {
            Label {
                Span {
                    Span(state.label)
                    if !state.isRequired {
                        Span("(optional)").class("field-optional")
                    }
                }
                Select {
                    for option in state.options {
                        Option(option.label)
                            .value(option.value)
                            .if(state.value == option.value) { $0.selected() }
                    }
                }
                .name(state.name)
                .id(state.name)
                .ariaInvalid(state.error == nil ? .false : .true)
                .if(state.error != nil) { $0.ariaErrorMessage(errorID) }
                .if(state.isRequired) { $0.required() }
            }
            .for(state.name)
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
            }
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-form-field")
    }
}
