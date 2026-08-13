import ContactDomain
import FeatherApplication
import FeatherContracts

public struct WriteForm: Scope {
    public let form: any FormRepository
    public let field: any FormFieldRepository
    public let mail: any SubmissionMailRepository
    public let submission: any SubmissionRepository

    public init(
        form: any FormRepository,
        field: any FormFieldRepository,
        mail: any SubmissionMailRepository,
        submission: any SubmissionRepository
    ) {
        self.form = form
        self.field = field
        self.mail = mail
        self.submission = submission
    }
}
