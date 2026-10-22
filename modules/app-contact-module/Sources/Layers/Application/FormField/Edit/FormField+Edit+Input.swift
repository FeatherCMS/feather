public import ContactDomain
public import ContactModule
public import FeatherApplication

extension FormField.Edit {
    public struct Input: DTO {
        public let id: String
        public let formId: String?
        public let key: String?
        public let type: FormField.Model.ItemType?
        public let label: String?
        public let allowedValues: [FormField.Model.Option]?
        public let isRequired: Bool?
        public let position: Int?

        public init(
            id: String,
            formId: String?,
            key: String? = nil,
            type: FormField.Model.ItemType? = nil,
            label: String? = nil,
            allowedValues: [FormField.Model.Option]? = nil,
            isRequired: Bool? = nil,
            position: Int? = nil
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
