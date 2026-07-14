import ContactDomain
import FeatherDatabase
import Infrastructure

extension ContactFormMailTable.Row {
    var asDomain: ContactFormMail {
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

public struct DatabaseContactFormMailRepository: ContactFormMailRepository {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func listBy(formId: String) async throws -> [ContactFormMail] {
        try await ContactFormMailTable(connection: connection).list(formId: formId).map(\.asDomain)
    }

    public func insert(_ model: ContactFormMail.New) async throws -> ContactFormMail {
        try await ContactFormMailTable(connection: connection).create(model: model).asDomain
    }

    public func deleteBy(formId: String) async throws {
        try await ContactFormMailTable(connection: connection).delete(formId: formId)
    }
}
