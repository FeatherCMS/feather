import Foundation
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
        maxConcurrentMediaProcessing: Int,
        publicBaseURL: URL
    ) {
        JobQueueSendMailJobController.register(
            on: queue,
            mailClient: mailClient
        )
        Issue.JobController.JobQueue.register(
            on: queue,
            databaseContext: databaseContext,
            mailClient: mailClient,
            publicBaseURL: publicBaseURL
        )
        Asset.File.GenerateVariant.JobController.JobQueue.register(
            on: queue,
            databaseContext: databaseContext,
            storageContext: storageContext,
            maxConcurrentProcessing: maxConcurrentMediaProcessing
        )
    }
}
