import AdminOpenAPI
import Foundation
import SystemApplication

extension AdminAPI {
    func map(
        _ job: JobDetail
    ) -> Components.Schemas.SystemJobSchema {
        .init(
            id: job.id,
            queueName: job.queueName,
            status: job.status,
            workerId: job.workerId,
            lastModified: job.lastModified.timeIntervalSince1970,
            payload: job.payload
        )
    }
}
