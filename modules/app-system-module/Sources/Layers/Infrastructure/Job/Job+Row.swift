import SystemModule
import FeatherDatabase
import Foundation
import SystemApplication

struct JobRow {
    let id: String
    let queueName: String
    let status: Int
    let workerId: String?
    let lastModified: Date
    let payload: String

    init(from row: any DatabaseRow) throws {
        id = try row.decode(column: "id", as: String.self)
        queueName = try row.decode(column: "queue_name", as: String.self)
        status = try row.decode(column: "status", as: Int.self)
        workerId = try row.decode(column: "worker_id", as: String?.self)
        lastModified = try row.decode(column: "last_modified", as: Date.self)
        payload = try row.decode(column: "payload", as: String.self)
    }

    var detail: SystemModule.Job.Detail.Output {
        .init(
            id: id,
            queueName: queueName,
            status: status,
            workerId: workerId,
            lastModified: lastModified,
            payload: payload
        )
    }
}
