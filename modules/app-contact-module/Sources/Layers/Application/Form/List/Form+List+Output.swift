package import ContactDomain
public import ContactModule
public import FeatherApplication

public import struct Foundation.Date

extension Form.List {
    public struct Output: DTO {
        public struct Item: DTO {
            public let id: String
            public let key: String
            public let name: String
            public let successMessage: String
            public let failureMessage: String
            public let submitLabel: String
            public let redirectUrl: String?
            public let fields: [Form.Field]
            public let mails: [Form.Mail]
            public let createdAt: Date
            public let updatedAt: Date

            package init(
                model: Form.Model,
                fields: [Form.Field],
                mails: [Form.Mail]
            ) {
                id = model.id
                key = model.key
                name = model.name
                successMessage = model.successMessage
                failureMessage = model.failureMessage
                submitLabel = model.submitLabel
                redirectUrl = model.redirectUrl
                self.fields = fields
                self.mails = mails
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
