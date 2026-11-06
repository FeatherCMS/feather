public import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDomain
public import FeatherInfrastructure
import Foundation

extension SubmissionMail.Table.Detail {
    var asDomain: SubmissionMail.Model {
        get throws {
            .init(
                id: id,
                formId: formId,
                mailFrom: mailFrom,
                mailTo: mailTo,
                subject: subject,
                additionalHeaders: try JSONDecoder()
                    .decode(
                        [String].self,
                        from: Data(additionalHeaders.utf8)
                    ),
                messageBody: messageBody,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}

extension SubmissionMail.Table.List {
    var asDomain: SubmissionMail.Model {
        get throws {
            try SubmissionMail.Table
                .Detail(
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
                .asDomain
        }
    }
}

extension SubmissionMail.Repository {
    public struct Database: Interface {
        public let context: DatabaseTransactionContext
        private let accessLayer: DatabaseAccessLayer<SubmissionMail.Table>

        public init(context: DatabaseTransactionContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func listBy(formId: String) async throws -> [SubmissionMail
            .Model]
        {
            try await accessLayer.select {
                $0.where(\.formId, equals: formId).order(by: \.id)
            }
            .map { try $0.asDomain }
        }

        public func insert(_ model: SubmissionMail.Model.New) async throws
            -> SubmissionMail.Model
        {
            let additionalHeaders = String(
                decoding: try JSONEncoder().encode(model.additionalHeaders),
                as: UTF8.self
            )
            let row = SubmissionMail.Table.Insert(
                id: context.idGenerator.generate(),
                formId: model.formId,
                mailFrom: model.mailFrom,
                mailTo: model.mailTo,
                subject: model.subject,
                additionalHeaders: additionalHeaders,
                messageBody: model.messageBody
            )
            try await accessLayer.insert(row)
            guard
                let saved = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: row.id
                )
            else {
                throw RepositoryError.notFound
            }
            return try saved.asDomain
        }

        public func deleteBy(formId: String) async throws {
            _ = try await accessLayer.delete(where: \.formId, equals: formId)
        }
    }
}
