import HTML
import SGML
import WebStandards

struct FormInputField: Component, FlowContent {
    struct State {
        var name: String
        var label: String
        var value: String?
        var error: String?
        var help: String?
        var id: String
        var type: Input.Types
        var placeholder: String?
        var autocomplete: String?
        var isRequired: Bool
        var isDisabled: Bool
        var isReadOnly: Bool
        var wrapperClass: String?
        var inputClass: String?

        init(
            name: String,
            label: String,
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

    var state: State

    init(
        state: State
    ) {
        self.state = state
    }

    init(
        name: String,
        label: String,
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

    func content() -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                input()
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
        .nilIfEmpty
    }
}
