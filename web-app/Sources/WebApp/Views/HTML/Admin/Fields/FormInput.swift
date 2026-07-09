import HTML
import SGML
import WebStandards

struct FormInput: Component, FlowContent {
    let name: String
    let label: String
    let value: String?
    let error: String?
    let help: String?
    let id: String
    let type: Input.Types
    let placeholder: String?
    let autocomplete: String?
    let isRequired: Bool
    let isDisabled: Bool
    let isReadOnly: Bool
    let wrapperClass: String?
    let inputClass: String?

    init(
        name: String,
        label: String,
        value: String? = nil,
        error: String? = nil,
        help: String? = nil,
        id: String? = nil
    ) {
        self.name = name
        self.label = label
        self.value = value
        self.error = error
        self.help = help
        self.id = id ?? name
        self.type = .text
        self.placeholder = nil
        self.autocomplete = nil
        self.isRequired = false
        self.isDisabled = false
        self.isReadOnly = false
        self.wrapperClass = nil
        self.inputClass = nil
    }

    private init(
        name: String,
        label: String,
        value: String?,
        error: String?,
        help: String?,
        id: String,
        type: Input.Types,
        placeholder: String?,
        autocomplete: String?,
        isRequired: Bool,
        isDisabled: Bool,
        isReadOnly: Bool,
        wrapperClass: String?,
        inputClass: String?
    ) {
        self.name = name
        self.label = label
        self.value = value
        self.error = error
        self.help = help
        self.id = id
        self.type = type
        self.placeholder = placeholder
        self.autocomplete = autocomplete
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.isReadOnly = isReadOnly
        self.wrapperClass = wrapperClass
        self.inputClass = inputClass
    }

    func content() -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                input()
            }
            .for(id)

            if let help {
                Span(help)
                    .id(helpID)
                    .class("field-help")
            }

            if let error {
                Span(error)
                    .id(errorID)
                    .class("field-error")
            }
        }
        .if(error != nil) { $0.class("has-error") }
        .if(wrapperClass != nil) {
            if let wrapperClass {
                return $0.class(wrapperClass)
            }
            return $0
        }
    }

    func type(
        _ value: Input.Types
    ) -> Self {
        copy(type: value)
    }

    func placeholder(
        _ value: String?
    ) -> Self {
        copy(placeholder: value)
    }

    func autocomplete(
        _ value: String?
    ) -> Self {
        copy(autocomplete: value)
    }

    func required(
        _ value: Bool = true
    ) -> Self {
        copy(isRequired: value)
    }

    func disabled(
        _ value: Bool = true
    ) -> Self {
        copy(isDisabled: value)
    }

    func readOnly(
        _ value: Bool = true
    ) -> Self {
        copy(isReadOnly: value)
    }

    func wrapperClass(
        _ value: String?
    ) -> Self {
        copy(wrapperClass: value)
    }

    func inputClass(
        _ value: String?
    ) -> Self {
        copy(inputClass: value)
    }

    private func input() -> Input {
        var input = Input()
            .type(type)
            .id(id)
            .name(name)

        if let value {
            input = input.value(value)
        }
        if let placeholder {
            input = input.placeholder(placeholder)
        }
        if let autocomplete {
            input = input.autocomplete(autocomplete)
        }
        if let describedBy {
            input = input.ariaDescribedBy(describedBy)
        }
        input = input.ariaInvalid(error == nil ? .false : .true)
        if error != nil {
            input = input.ariaErrorMessage(errorID)
        }
        if isRequired {
            input = input.required()
        }
        if isDisabled {
            input = input.disabled()
        }
        if isReadOnly {
            input = input.readOnly()
        }
        if let inputClass {
            input = input.class(inputClass)
        }

        return input
    }

    private func fieldLabel() -> some BasicTag {
        Span {
            InlineText(label)
            if !isRequired {
                Span(" (Optional)")
                    .class("field-label__optional")
            }
        }
        .class("field-label")
    }

    private var helpID: String {
        "\(id)-help"
    }

    private var errorID: String {
        "\(id)-error"
    }

    private var describedBy: String? {
        [
            help == nil ? nil : helpID,
            error == nil ? nil : errorID,
        ]
        .compactMap { $0 }
        .joined(separator: " ")
        .nilIfEmpty
    }

    private func copy(
        type: Input.Types? = nil,
        placeholder: String? = nil,
        autocomplete: String? = nil,
        isRequired: Bool? = nil,
        isDisabled: Bool? = nil,
        isReadOnly: Bool? = nil,
        wrapperClass: String? = nil,
        inputClass: String? = nil
    ) -> Self {
        .init(
            name: name,
            label: label,
            value: value,
            error: error,
            help: help,
            id: id,
            type: type ?? self.type,
            placeholder: placeholder ?? self.placeholder,
            autocomplete: autocomplete ?? self.autocomplete,
            isRequired: isRequired ?? self.isRequired,
            isDisabled: isDisabled ?? self.isDisabled,
            isReadOnly: isReadOnly ?? self.isReadOnly,
            wrapperClass: wrapperClass ?? self.wrapperClass,
            inputClass: inputClass ?? self.inputClass
        )
    }
}
