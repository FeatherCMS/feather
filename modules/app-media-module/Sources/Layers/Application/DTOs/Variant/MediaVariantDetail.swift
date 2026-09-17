import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct MediaVariantDetail: DTO {
    public let id: String
    public let key: String
    public let name: String
    public let isRequired: Bool
    public let isActive: Bool
    public let processors: [MediaVariantProcessorList.Item]
    public let createdAt: Date
    public let updatedAt: Date

    public init(id: String, key: String, name: String, isRequired: Bool, isActive: Bool, processors: [MediaVariantProcessorList.Item], createdAt: Date, updatedAt: Date) {
        self.id = id
        self.key = key
        self.name = name
        self.isRequired = isRequired
        self.isActive = isActive
        self.processors = processors
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
