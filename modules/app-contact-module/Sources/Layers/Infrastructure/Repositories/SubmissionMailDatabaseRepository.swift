public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure

extension SubmissionMailTable.Row {
    var asDomain: SubmissionMail.Model {
        .init(
            id: id,
            formId: formId,
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

public struct SubmissionMailDatabaseRepository: SubmissionMail.Repository.Interface {
    public let context: DatabaseTransactionContext
    public init(context: DatabaseTransactionContext) {
        self.context = context
    }

    public func listBy(formId: String) async throws -> [SubmissionMail.Model] {
        try await SubmissionMailTable(connection: context.connection)
            .list(formId: formId).map(\.asDomain)
    }

    public func insert(
        _ model: SubmissionMail.Model.New
    ) async throws -> SubmissionMail.Model {
        try await SubmissionMailTable(connection: context.connection)
            .create(model: model, id: context.idGenerator.generate()).asDomain
    }

    public func deleteBy(formId: String) async throws {
        try await SubmissionMailTable(connection: context.connection)
            .delete(formId: formId)
    }
}
