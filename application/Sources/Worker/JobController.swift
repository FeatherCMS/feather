import FeatherDatabase
import FeatherApplication
import FeatherInfrastructure
import FeatherMail
import Jobs
import MediaInfrastructure
import MediaModule
import NewsletterInfrastructure
import NewsletterModule

struct JobController {
    init(
        queue: some JobQueueProtocol,
        mailClient: any MailClient,
        databaseContext: DatabaseClientContext,
        storageContext: StorageClientContext,
        maxConcurrentMediaProcessing: Int
    ) {
        JobQueueSendMailJobController.register(
            on: queue,
            mailClient: mailClient
        )
        Issue.JobController.JobQueue.register(
            on: queue,
            databaseContext: databaseContext,
            mailClient: mailClient
        )
        Asset.File.GenerateVariant.JobController.JobQueue.register(
            on: queue,
            databaseContext: databaseContext,
            storageContext: storageContext,
            maxConcurrentProcessing: maxConcurrentMediaProcessing
        )
    }
}
