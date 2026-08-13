import FeatherApplication
import FeatherContracts
import Foundation

public struct JobDetail: DTO, Sendable {
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
