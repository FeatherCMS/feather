import Application
import ContactInfrastructure
import Infrastructure
import ContactApplication

struct ContactModule: Sendable {
    private let infrastructure: AppInfrastructure
    private let authorizer: any Authorizer

    init(
        infrastructure: AppInfrastructure,
        authorizer: any Authorizer
    ) {
        self.infrastructure = infrastructure
        self.authorizer = authorizer
    }

    func aggregatedPermissions() {
        for permission in ContactPermissions.allPermissions() {
            print(permission.rawValue)
        }
    }

    func authorize(permission: PermissionKey) async throws {
        let subject = try await CurrentSubject.require()
        guard try await authorizer.can(subject: subject, perform: ContactPermissionAction(key: permission)) else {
            throw AuthError(kind: .forbidden, message: permission.rawValue)
        }
    }
}

extension ContactModule {
    private func contactFormTransaction() -> DatabaseTransactionExecutor<WriteContactForm> {
        DatabaseTransactionExecutor(
            database: infrastructure.database,
            scope: { connection in
                WriteContactForm(
                    form: DatabaseContactFormRepository(connection: connection),
                    item: DatabaseContactFormItemRepository(connection: connection),
                    mail: DatabaseContactFormMailRepository(connection: connection),
                    submission: DatabaseContactFormSubmissionRepository(connection: connection)
                )
            }
        )
    }

    func makeCreateContactFormItem() -> CreateContactFormItem {
        .init(transaction: contactFormTransaction(), idGenerator: infrastructure.idGenerator)
    }
    func makeListContactFormItems() -> ListContactFormItems { .init(transaction: contactFormTransaction()) }
    func makeGetContactFormItem() -> GetContactFormItem { .init(transaction: contactFormTransaction()) }
    func makeUpdateContactFormItem() -> UpdateContactFormItem { .init(transaction: contactFormTransaction()) }
    func makeDeleteContactFormItem() -> DeleteContactFormItem { .init(transaction: contactFormTransaction()) }

    func makeCreateContactForm() -> CreateContactForm { .init(transaction: contactFormTransaction(), idGenerator: infrastructure.idGenerator) }
    func makeListContactForms() -> ListContactForms { .init(transaction: contactFormTransaction()) }
    func makeGetContactForm() -> GetContactForm { .init(transaction: contactFormTransaction()) }
    func makeUpdateContactForm() -> UpdateContactForm { .init(transaction: contactFormTransaction(), idGenerator: infrastructure.idGenerator) }
    func makeDeleteContactForm() -> DeleteContactForm { .init(transaction: contactFormTransaction()) }

    func makeSubmitContactForm() -> SubmitContactForm {
        .init(transaction: contactFormTransaction(), idGenerator: infrastructure.idGenerator, clock: DefaultClock())
    }

    func makeListContactFormSubmissions() -> ListContactFormSubmissions { .init(transaction: contactFormTransaction()) }
    func makeGetContactFormSubmission() -> GetContactFormSubmission { .init(transaction: contactFormTransaction()) }
    func makeUpdateContactFormSubmission() -> UpdateContactFormSubmission { .init(transaction: contactFormTransaction()) }
    func makeDeleteContactFormSubmission() -> DeleteContactFormSubmission { .init(transaction: contactFormTransaction()) }

}
