public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Form.Detail.Query {
    public struct Database: Interface {
        private let context: any DatabaseContext
        private let formAccessLayer: DatabaseAccessLayer<Form.Table>
        private let mailAccessLayer: DatabaseAccessLayer<SubmissionMail.Table>

        public init(context: any DatabaseContext) {
            self.context = context
            self.formAccessLayer = .init(context: context)
            self.mailAccessLayer = .init(context: context)
        }

        public func find(key: String) async throws -> Form.Detail.Output {
            guard
                let form = try await formAccessLayer.selectFirst(
                    by: \.key,
                    equals: key
                )
            else {
                throw QueryError.notFound
            }

            let fieldRows = try await FormFieldTable(
                connection: context.connection
            )
            .list(formId: form.id)
            let fields = try fieldRows.map { row in
                guard let type = FormField.Model.ItemType(rawValue: row.type)
                else {
                    throw QueryError(
                        reason: .database,
                        logMessage:
                            "Invalid contact form field type: \(row.type)",
                        userFriendlyMessage:
                            "Unable to read the contact form."
                    )
                }
                let model = FormField.Model(
                    id: row.id,
                    formId: row.formId,
                    key: row.key,
                    type: type,
                    label: row.label,
                    allowedValues: try row.allowedValues(),
                    isRequired: row.isRequired,
                    position: row.position,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                return Form.Field(model: model)
            }

            let mailRows = try await mailAccessLayer.select(
                as: SubmissionMail.Table.List.self
            ) {
                $0.where(\.formId, equals: form.id).order(by: \.id)
            }
            let mails = try mailRows.map { row in
                let model = SubmissionMail.Model(
                    id: row.id,
                    formId: row.formId,
                    mailFrom: row.mailFrom,
                    mailTo: row.mailTo,
                    subject: row.subject,
                    additionalHeaders: try JSONDecoder()
                        .decode(
                            [String].self,
                            from: Data(row.additionalHeaders.utf8)
                        ),
                    messageBody: row.messageBody,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                return Form.Mail(model: model)
            }

            return .init(
                id: form.id,
                key: form.key,
                name: form.name,
                successMessage: form.successMessage,
                failureMessage: form.failureMessage,
                redirectUrl: form.redirectUrl,
                fields: fields,
                mails: mails,
                createdAt: form.createdAt,
                updatedAt: form.updatedAt
            )
        }
    }
}
