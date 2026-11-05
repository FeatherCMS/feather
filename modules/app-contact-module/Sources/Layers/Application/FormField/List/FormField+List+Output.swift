public import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension FormField.List {
    public struct Output: DTO {
        public struct Item: DTO {
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

            package init(model: FormField.Model) {
                id = model.id
                formId = model.formId
                key = model.key
                type = model.type
                label = model.label
                allowedValues = model.allowedValues
                isRequired = model.isRequired
                position = model.position
                createdAt = model.createdAt
                updatedAt = model.updatedAt
            }
        }

        public let items: [Item]

        package init(items: [Item]) {
            self.items = items
        }
    }
}
