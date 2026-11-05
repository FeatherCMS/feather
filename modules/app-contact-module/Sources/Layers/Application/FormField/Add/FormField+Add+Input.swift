public import ContactDomain
public import ContactModule
public import FeatherApplication

extension FormField.Add {
    public struct Input: DTO {
        public let formId: String?
        public let key: String
        public let type: FormField.Model.ItemType
        public let label: String
        public let allowedValues: [FormField.Model.Option]
        public let isRequired: Bool
        public let position: Int

        public init(
            formId: String?,
            key: String,
            type: FormField.Model.ItemType,
            label: String,
            allowedValues: [FormField.Model.Option] = [],
            isRequired: Bool = false,
            position: Int = 0
        ) {
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
