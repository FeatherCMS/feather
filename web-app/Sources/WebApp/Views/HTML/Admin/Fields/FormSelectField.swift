import HTML
import SGML
import CSS
import WebStandards

struct FormSelectField: Component, FlowContent {
    struct Option {
        var label: String
        var value: String
        var isDisabled: Bool

        init(
            label: String,
            value: String,
            isDisabled: Bool = false
        ) {
            self.label = label
            self.value = value
            self.isDisabled = isDisabled
        }
    }

    struct State {
        var name: String
        var label: String
        var options: [Option]
        var selectedValue: String?
        var error: String?
        var help: String?
        var id: String
        var isRequired: Bool
        var isDisabled: Bool
        var wrapperClass: String?
        var selectClass: String?

        init(
            name: String,
            label: String,
            options: [Option],
            selectedValue: String? = nil,
            error: String? = nil,
            help: String? = nil,
            id: String? = nil,
            isRequired: Bool = false,
            isDisabled: Bool = false,
            wrapperClass: String? = nil,
            selectClass: String? = nil
        ) {
            self.name = name
            self.label = label
            self.options = options
            self.selectedValue = selectedValue
            self.error = error
            self.help = help
            self.id = id ?? name
            self.isRequired = isRequired
            self.isDisabled = isDisabled
            self.wrapperClass = wrapperClass
            self.selectClass = selectClass
        }
    }

    var state: State

    init(state: State) {
        self.state = state
    }

    init(
        name: String,
        label: String,
        options: [Option],
        selectedValue: String? = nil,
        error: String? = nil,
        help: String? = nil,
        id: String? = nil,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        wrapperClass: String? = nil,
        selectClass: String? = nil
    ) {
        self.state = .init(
            name: name,
            label: label,
            options: options,
            selectedValue: selectedValue,
            error: error,
            help: help,
            id: id,
            isRequired: isRequired,
            isDisabled: isDisabled,
            wrapperClass: wrapperClass,
            selectClass: selectClass
        )
    }

    func selectors() -> [any Selector] {
        Class("field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
        Custom("label .field-label__optional") {
            Color(.variable("cms-tertiary-font"))
        }
    }

    func content() -> some BasicTag {
        Section {
            Label {
                fieldLabel()
                select()
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

    private func select() -> Select {
        var select = Select {
            for option in state.options {
                HTML.Option(option.label)
                    .value(option.value)
                    .if(option.value == state.selectedValue) {
                        $0.selected()
                    }
                    .if(option.isDisabled) {
                        $0.disabled()
                    }
            }
        }
        .id(state.id)
        .name(state.name)

        if let describedBy {
            select = select.ariaDescribedBy(describedBy)
        }
        select = select.ariaInvalid(state.error == nil ? .false : .true)
        if state.error != nil {
            select = select.ariaErrorMessage(errorID)
        }
        if state.isRequired {
            select = select.required()
        }
        if state.isDisabled {
            select = select.disabled()
        }
        if let selectClass = state.selectClass {
            select = select.class(selectClass)
        }

        return select
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

    private var helpID: String { "\(state.id)-help" }
    private var errorID: String { "\(state.id)-error" }

    private var describedBy: String? {
        [
            state.help == nil ? nil : helpID,
            state.error == nil ? nil : errorID
        ]
        .compactMap { $0 }
        .joined(separator: " ")
        .nilIfEmpty
    }
}
