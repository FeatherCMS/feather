import ContactDomain
import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct FormFieldDetail: DTO {
    public let id: String
    public let formId: String
    public let key: String
    public let type: FormField.ItemType
    public let label: String
    public let allowedValues: [FormField.Option]
    public let isRequired: Bool
    public let position: Int
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        formId: String,
        key: String,
        type: FormField.ItemType,
        label: String,
        allowedValues: [FormField.Option],
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
