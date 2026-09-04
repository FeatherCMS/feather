import CSS
import FeatherContracts
import HTML
import SGML
import WebComponents
import WebBuilders

public struct FormInputField: Leaf {
    public struct State: Sendable {
        public var name: String
        public var label: String
        public var prefix: String?
        public var value: String?
        public var error: String?
        public var help: String?
        public var id: String
        public var type: Input.Types
        public var placeholder: String?
        public var autocomplete: String?
        public var isRequired: Bool
        public var isDisabled: Bool
        public var isReadOnly: Bool
        public var wrapperClass: String?
        public var inputClass: String?

        public init(
            name: String,
            label: String,
            prefix: String? = nil,
            value: String? = nil,
            error: String? = nil,
            help: String? = nil,
            id: String? = nil,
            type: Input.Types = .text,
            placeholder: String? = nil,
            autocomplete: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            isReadOnly: Bool = false,
            wrapperClass: String? = nil,
            inputClass: String? = nil
        ) {
            self.name = name
            self.label = label
            self.prefix = prefix
            self.value = value
            self.error = error
            self.help = help
            self.id = id ?? name
            self.type = type
            self.placeholder = placeholder
            self.autocomplete = autocomplete
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.isReadOnly = isReadOnly
            self.wrapperClass = wrapperClass
            self.inputClass = inputClass
        }
    }

    public var state: State

    public init(
        state: State
    ) {
        self.state = state
    }

    public init(
        name: String,
        label: String,
        prefix: String? = nil,
        value: String? = nil,
        error: String? = nil,
        help: String? = nil,
        id: String? = nil,
        type: Input.Types = .text,
        placeholder: String? = nil,
        autocomplete: String? = nil,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        isReadOnly: Bool = false,
        wrapperClass: String? = nil,
        inputClass: String? = nil
    ) {
        self.state = .init(
            name: name,
            label: label,
            prefix: prefix,
            value: value,
            error: error,
            help: help,
            id: id,
            type: type,
            placeholder: placeholder,
            autocomplete: autocomplete,
            isRequired: isRequired,
            isDisabled: isDisabled,
            isReadOnly: isReadOnly,
            wrapperClass: wrapperClass,
            inputClass: inputClass
        )
    }

    public func selectors() -> [any Selector] {
        Class("field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Custom("label .field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
    }

    public func renderHTML() -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                if let prefix = state.prefix {
                    Div {
                        Span(prefix)
                            .class("admin-metadata-fields__prefix")
                        input()
                    }
                    .class("admin-metadata-fields__prefixed-input")
                }
                else {
                    input()
                }
            }
            .for(state.id)

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
        .if(state.wrapperClass != nil) {
            if let wrapperClass = state.wrapperClass {
                return $0.class(wrapperClass)
            }
            return $0
        }
    }

    private func input() -> Input {
        var input = Input()
            .type(state.type)
            .id(state.id)
            .name(state.name)

        if let value = state.value {
            input = input.value(value)
        }
        if let placeholder = state.placeholder {
            input = input.placeholder(placeholder)
        }
        if let autocomplete = state.autocomplete {
            input = input.autocomplete(autocomplete)
        }
        if let describedBy {
            input = input.ariaDescribedBy(describedBy)
        }
        input = input.ariaInvalid(state.error == nil ? .false : .true)
        if state.error != nil {
            input = input.ariaErrorMessage(errorID)
        }
        if state.isRequired {
            input = input.required()
        }
        if state.isDisabled {
            input = input.disabled()
        }
        if state.isReadOnly {
            input = input.readOnly()
        }
        if let inputClass = state.inputClass {
            input = input.class(inputClass)
        }

        return input
    }

    private func fieldLabel() -> some BasicTag {
        Span {
            InlineText(state.label)
            if !state.isRequired {
                Span(" (Optional)")
                    .class("field-label__optional")
            }
        }
        .class("field-label")
    }

    private var helpID: String {
        "\(state.id)-help"
    }

    private var errorID: String {
        "\(state.id)-error"
    }

    private var describedBy: String? {
        [
            state.help == nil ? nil : helpID,
            state.error == nil ? nil : errorID,
        ]
        .compactMap { $0 }
        .joined(separator: " ")
        .emptyToNil
    }
}
