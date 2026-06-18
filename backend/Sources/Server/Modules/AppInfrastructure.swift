import FeatherDatabase
import Application
import Jobs

struct AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let jobQueue: any JobQueueProtocol
    let mediaStorageRootPath: String
}
