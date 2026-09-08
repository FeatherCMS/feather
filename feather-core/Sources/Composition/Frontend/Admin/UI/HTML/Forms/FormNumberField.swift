import CSS
import FeatherContracts
import HTML
import SGML
import WebStandards

public struct FormNumberField: Component, FlowContent {
    public struct State: Sendable {
        var name: String
        var label: String
        var value: String?
        var error: String?
        var help: String?
        var id: String
        var minimum: Int?
        var maximum: Int?
        var step: Int
        var isRequired: Bool
        var isDisabled: Bool
        var isReadOnly: Bool
        var wrapperClass: String?
        var inputClass: String?

        public init(
            name: String,
            label: String,
            value: String? = nil,
            error: String? = nil,
            help: String? = nil,
            id: String? = nil,
            minimum: Int? = nil,
            maximum: Int? = nil,
            step: Int = 1,
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
            self.minimum = minimum
            self.maximum = maximum
            self.step = step
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
        value: String? = nil,
        error: String? = nil,
        help: String? = nil,
        id: String? = nil,
        minimum: Int? = nil,
        maximum: Int? = nil,
        step: Int = 1,
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
            minimum: minimum,
            maximum: maximum,
            step: step,
            isRequired: isRequired,
            isDisabled: isDisabled,
            isReadOnly: isReadOnly,
            wrapperClass: wrapperClass,
            inputClass: inputClass
        )
    }

    public func selectors(
        // empty
    ) -> [any Selector] {
        Class("field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Custom("label .field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
    }

    public func content(
        // empty
    ) -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                input()
            }
            .for(state.id)

            if let help = state.help {
                Span(help).id(helpID).class("field-help")
            }
            if let error = state.error {
                Span(error).id(errorID).class("field-error")
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

    private func input(
        // empty
    ) -> Input {
        var input = Input()
            .type(.number)
            .id(state.id)
            .name(state.name)
            .step(state.step)

        if let value = state.value {
            input = input.value(value)
        }
        if let minimum = state.minimum {
            input = input.min(Double(minimum))
        }
        if let maximum = state.maximum {
            input = input.max(Double(maximum))
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

    private func fieldLabel(
        // empty
    ) -> some BasicTag {
        Span {
            InlineText(state.label)
            if !state.isRequired {
                Span(" (Optional)").class("field-label__optional")
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
