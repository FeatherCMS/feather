public import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension FormField.Detail {
    public struct Output: DTO {
        public let id: String
        public let formId: String
        public let key: String
        public let type: FormField.Model.ItemType
        public let label: String
        public let allowedValues: [FormField.Model.Option]
        public let isRequired: Bool
        public let position: Int
        public let createdAt: Date
        public let updatedAt: Date

        package init(
            id: String,
            formId: String,
            key: String,
            type: FormField.Model.ItemType,
            label: String,
            allowedValues: [FormField.Model.Option],
            isRequired: Bool,
            position: Int,
            createdAt: Date,
            updatedAt: Date
        ) {
            self.id = id
            self.formId = formId
            self.key = key
            self.type = type
            self.label = label
            self.allowedValues = allowedValues
            self.isRequired = isRequired
            self.position = position
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
}

extension FormField.Model {
    var asDetail: FormField.Detail.Output {
        .init(
            id: id,
            formId: formId,
            key: key,
            type: type,
            label: label,
            allowedValues: allowedValues,
            isRequired: isRequired,
            position: position,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
