public import ContactDomain
public import ContactModule
public import FeatherApplication
public import FeatherDomain

extension FormField.Edit {
    public struct Input: DTO {
        public let id: String
        public let formId: String?
        public let key: FieldChange<String>
        public let type: FieldChange<FormField.Model.ItemType>
        public let label: FieldChange<String>
        public let allowedValues: FieldChange<[FormField.Model.Option]>
        public let isRequired: FieldChange<Bool>
        public let position: FieldChange<Int>

        public init(
            id: String,
            formId: String?,
            key: FieldChange<String> = .unchanged,
            type: FieldChange<FormField.Model.ItemType> = .unchanged,
            label: FieldChange<String> = .unchanged,
            allowedValues: FieldChange<[FormField.Model.Option]> = .unchanged,
            isRequired: FieldChange<Bool> = .unchanged,
            position: FieldChange<Int> = .unchanged
        ) {
            self.id = id
            self.formId = formId
            self.key = key
            self.type = type
            self.label = label
            self.allowedValues = allowedValues
            self.isRequired = isRequired
            self.position = position
        }
    }
}
