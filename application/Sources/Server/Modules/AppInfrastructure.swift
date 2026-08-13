import FeatherContracts
import FeatherDatabase
import FeatherApplication
import FeatherDomain
import FeatherInfrastructure
import Jobs

struct AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let events: any EventPublisher
    let jobQueue: any JobQueueProtocol
    let mediaStorageRootPath: String
}
