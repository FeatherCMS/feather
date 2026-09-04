import CSS
import FeatherContracts
import HTML
import SGML
import WebComponents
import WebBuilders

public struct FormTextAreaField: Leaf {
    public struct State: Sendable {
        var name: String
        var label: String
        var value: String?
        var error: String?
        var help: String?
        var id: String
        var placeholder: String?
        var rows: Int
        var isRequired: Bool
        var isDisabled: Bool
        var isReadOnly: Bool
        var wrapperClass: String?
        var textareaClass: String?

        public init(
            name: String,
            label: String,
            value: String? = nil,
            error: String? = nil,
            help: String? = nil,
            id: String? = nil,
            placeholder: String? = nil,
            rows: Int = 8,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            isReadOnly: Bool = false,
            wrapperClass: String? = nil,
            textareaClass: String? = nil
        ) {
            self.name = name
            self.label = label
            self.value = value
            self.error = error
            self.help = help
            self.id = id ?? name
            self.placeholder = placeholder
            self.rows = rows
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.isReadOnly = isReadOnly
            self.wrapperClass = wrapperClass
            self.textareaClass = textareaClass
        }
    }

    public var state: State

    public init(state: State) {
        self.state = state
    }

    public init(
        name: String,
        label: String,
        value: String? = nil,
        error: String? = nil,
        help: String? = nil,
        id: String? = nil,
        placeholder: String? = nil,
        rows: Int = 8,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        isReadOnly: Bool = false,
        wrapperClass: String? = nil,
        textareaClass: String? = nil
    ) {
        self.state = .init(
            name: name,
            label: label,
            value: value,
            error: error,
            help: help,
            id: id,
            placeholder: placeholder,
            rows: rows,
            isRequired: isRequired,
            isDisabled: isDisabled,
            isReadOnly: isReadOnly,
            wrapperClass: wrapperClass,
            textareaClass: textareaClass
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

    public func renderHTML() -> Section {
        Section {
            Label {
                fieldLabel()
                textarea()
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

    private func textarea() -> Textarea {
        var textarea = Textarea(state.value ?? "")
            .id(state.id)
            .name(state.name)
            .rows(state.rows)

        if let placeholder = state.placeholder {
            textarea = textarea.placeholder(placeholder)
        }
        if let describedBy {
            textarea = textarea.ariaDescribedBy(describedBy)
        }
        textarea = textarea.ariaInvalid(state.error == nil ? .false : .true)
        if state.error != nil {
            textarea = textarea.ariaErrorMessage(errorID)
        }
        if state.isRequired {
            textarea = textarea.required()
        }
        if state.isDisabled {
            textarea = textarea.disabled()
        }
        if state.isReadOnly {
            textarea = textarea.readOnly()
        }
        if let textareaClass = state.textareaClass {
            textarea = textarea.class(textareaClass)
        }
        return textarea
    }

    private func fieldLabel() -> some BasicTag {
        Span {
            InlineText(state.label)
            if !state.isRequired {
                Span(" (Optional)").class("field-label__optional")
            }
        }
        .class("field-label")
    }

    private var helpID: String { "\(state.id)-help" }
    private var errorID: String { "\(state.id)-error" }

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
