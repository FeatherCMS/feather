public import FeatherApplication
public import Foundation
public import SystemModule

extension Job.Search {
    public struct Output: DTO, Sendable {
        public struct Item: DTO, Sendable {
            public let id: String
            public let queueName: String
            public let status: Int
            public let workerId: String?
            public let lastModified: Date
            public let payload: String

            public init(
                id: String,
                queueName: String,
                status: Int,
                workerId: String?,
                lastModified: Date,
                payload: String
            ) {
                self.id = id
                self.queueName = queueName
                self.status = status
                self.workerId = workerId
                self.lastModified = lastModified
                self.payload = payload
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
