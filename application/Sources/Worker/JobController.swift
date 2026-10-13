import FeatherDatabase
import FeatherApplication
import FeatherInfrastructure
import FeatherMail
import Jobs
import MediaInfrastructure
import NewsletterInfrastructure

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
        JobQueueNewsletterIssueJobController.register(
            on: queue,
            databaseContext: databaseContext,
            mailClient: mailClient
        )
        JobQueueMediaJobController.register(
            on: queue,
            databaseContext: databaseContext,
            storageContext: storageContext,
            maxConcurrentProcessing: maxConcurrentMediaProcessing
        )
    }
}
