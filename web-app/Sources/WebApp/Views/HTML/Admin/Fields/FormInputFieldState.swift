import HTML

struct FormInputFieldState {
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
