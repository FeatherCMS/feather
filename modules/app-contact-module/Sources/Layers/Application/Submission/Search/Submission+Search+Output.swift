public import ContactDomain
public import ContactModule
public import FeatherApplication
public import struct Foundation.Date

extension Submission.Search {
    public struct Output: DTO {
        public struct Item: Sendable {
            public let id: String
            public let formKey: String
            public let formName: String
            public let status: Submission.Model.Status
            public let createdAt: Date
            public let email: String?

            public init(
                id: String,
                formKey: String,
                formName: String,
                status: Submission.Model.Status,
                createdAt: Date,
                email: String?
            ) {
                self.id = id
                self.formKey = formKey
                self.formName = formName
                self.status = status
                self.createdAt = createdAt
                self.email = email
            }
        }

        public let items: [Item]
        public let total: Int

        public init(items: [Item], total: Int) {
            self.items = items
            self.total = total
        }
    }
}
