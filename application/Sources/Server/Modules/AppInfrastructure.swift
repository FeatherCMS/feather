import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import Jobs
import MediaApplication

struct AppInfrastructure: Sendable {
    let databaseContext: DatabaseClientContext
    let events: any EventPublisher
    let jobQueue: any JobQueueProtocol
    let storageContext: StorageClientContext
}
