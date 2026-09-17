import FeatherContracts
import FeatherDatabase
import FeatherApplication
import FeatherDomain
import FeatherInfrastructure
import Jobs
import MediaApplication

struct AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let events: any EventPublisher
    let jobQueue: any JobQueueProtocol
    let mediaStorage: any MediaStorage
}
