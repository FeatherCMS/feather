import FeatherDatabase
import Application
import Infrastructure
import Jobs

final class AppInfrastructure: Sendable {
    let database: any DatabaseClient
    let idGenerator: any IDGenerator
    let hooks: HookRegistry<AppHookContext>
    let jobQueue: any JobQueueProtocol
    let mediaStorageRootPath: String

    init(
        database: any DatabaseClient,
        idGenerator: any IDGenerator,
        hooks: HookRegistry<AppHookContext>,
        jobQueue: any JobQueueProtocol,
        mediaStorageRootPath: String
    ) {
        self.database = database
        self.idGenerator = idGenerator
        self.hooks = hooks
        self.jobQueue = jobQueue
        self.mediaStorageRootPath = mediaStorageRootPath
    }
}
