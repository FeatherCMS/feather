import FeatherDatabase
import Application
import Infrastructure
import Jobs

final class AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let eventHandlers: EventHandlerRegistry<AppEventContext>
    let jobQueue: any JobQueueProtocol
    let mediaStorageRootPath: String

    init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        eventHandlers: EventHandlerRegistry<AppEventContext>,
        jobQueue: any JobQueueProtocol,
        mediaStorageRootPath: String
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.eventHandlers = eventHandlers
        self.jobQueue = jobQueue
        self.mediaStorageRootPath = mediaStorageRootPath
    }
}
