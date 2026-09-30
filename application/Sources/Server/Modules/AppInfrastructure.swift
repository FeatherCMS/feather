import FeatherContracts
import FeatherDatabase
import FeatherDomain
import Jobs
import MediaApplication

struct AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let events: any EventPublisher
    let jobQueue: any JobQueueProtocol
    let storageContext: StorageContext
}
