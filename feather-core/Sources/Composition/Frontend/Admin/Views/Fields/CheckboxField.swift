import CSS
import HTML
import SGML
import WebStandards

public struct CheckboxField: Component, FlowContent {

    public enum LabelPosition: String, Codable, Sendable {
        case before
        case after
    }

    public struct State: FeatherAdmin.Object {
        var name: String
        var label: String
        var isChecked: Bool
        var error: String?
        var id: String
        var labelPosition: LabelPosition
        var isDisabled: Bool
        var wrapperClass: String?
        var inputClass: String?

        public init(
            name: String,
            label: String,
            isChecked: Bool = false,
            error: String? = nil,
            id: String? = nil,
            labelPosition: LabelPosition = .after,
            isDisabled: Bool = false,
            wrapperClass: String? = nil,
            inputClass: String? = nil
        ) {
            self.name = name
            self.label = label
            self.isChecked = isChecked
            self.error = error
            self.id = id ?? name
            self.labelPosition = labelPosition
            self.isDisabled = isDisabled
            self.wrapperClass = wrapperClass
            self.inputClass = inputClass
        }

        public init(
            key: String,
            label: String,
            value: Bool,
            error: String? = nil,
            id: String? = nil,
            labelPosition: LabelPosition = .after,
            isDisabled: Bool = false,
            wrapperClass: String? = nil,
            inputClass: String? = nil
        ) {
            self.init(
                name: key,
                label: label,
                isChecked: value,
                error: error,
                id: id,
                labelPosition: labelPosition,
                isDisabled: isDisabled,
                wrapperClass: wrapperClass,
                inputClass: inputClass
            )
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
        isChecked: Bool = false,
        error: String? = nil,
        id: String? = nil,
        labelPosition: LabelPosition = .after,
        isDisabled: Bool = false,
        wrapperClass: String? = nil,
        inputClass: String? = nil
    ) {
        self.state = .init(
            name: name,
            label: label,
            isChecked: isChecked,
            error: error,
            id: id,
            labelPosition: labelPosition,
            isDisabled: isDisabled,
            wrapperClass: wrapperClass,
            inputClass: inputClass
        )
    }

    public func selectors() -> [any Selector] {
        Class("checkbox-field") {
            Display(.inlineFlex)
            AlignItems(.center)
            Gap(8.px)
            Cursor(.pointer)
            FontSize(0.95.rem)
            LineHeight(1)
        }
        Custom(".cms-form label.checkbox-field") {
            Display(.inlineFlex)
            AlignItems(.center)
            Gap(8.px)
            FontSize(0.95.rem)
            LineHeight(1)
        }
        Custom(".checkbox-field input[type=\"checkbox\"]") {
            Margin(0.px)
            FlexShrink(0)
            FontSize(0.95.rem)
            VerticalAlign(.middle)
        }
        Class("checkbox-field__label") {
            Display(.inlineFlex)
            AlignItems(.center)
            FontSize(0.95.rem)
            LineHeight(1)
        }
    }

    public func content() -> some BasicTag {
        Section {
            Label {
                if state.labelPosition == .before {
                    label()
                    input()
                }
                else {
                    input()
                    label()
                }
            }
            .for(state.id)
            .class("checkbox-field")

            if let error = state.error {
                Span(error)
                    .id(errorID)
                    .class("field-error", "error")
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

    private func label() -> Span {
        Span(state.label)
            .class("checkbox-field__label")
    }

    private func input() -> Input {
        var input = Input()
            .type(.checkbox)
            .id(state.id)
            .name(state.name)

        if let describedBy {
            input = input.ariaDescribedBy(describedBy)
        }
        input = input.ariaInvalid(state.error == nil ? .false : .true)
        if state.error != nil {
            input = input.ariaErrorMessage(errorID)
        }
        if state.isChecked {
            input = input.checked()
        }
        if state.isDisabled {
            input = input.disabled()
        }
        if let inputClass = state.inputClass {
            input = input.class(inputClass)
        }

        return input
    }

    private var errorID: String {
        "\(state.id)-error"
    }

    private var describedBy: String? {
        state.error == nil ? nil : errorID
    }
}
