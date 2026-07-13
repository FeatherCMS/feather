import Application
import ContactDomain

public struct WriteContactForm: Scope {
    public let form: any ContactFormRepository
    public let item: any ContactFormItemRepository
    public let submission: any ContactFormSubmissionRepository

    public init(
        form: any ContactFormRepository,
        item: any ContactFormItemRepository,
        submission: any ContactFormSubmissionRepository
    ) {
        self.form = form
        self.item = item
        self.submission = submission
    }
}
