import FeatherApplication
import NewsletterModule

public import struct Foundation.Date

extension Issue.Schedule {
    public struct Input: DTO {
        public let id: String
        public let scheduledDate: Date

        public init(id: String, scheduledDate: Date) {
            self.id = id
            self.scheduledDate = scheduledDate
        }
    }
}
