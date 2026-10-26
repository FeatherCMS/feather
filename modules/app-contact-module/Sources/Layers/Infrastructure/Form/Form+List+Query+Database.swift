public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherDBAL
public import FeatherInfrastructure
import Foundation

extension Form.List.Query {
    public struct Database: Interface {
        private let formAccessLayer: DatabaseAccessLayer<Form.Table>
        private let mailAccessLayer: DatabaseAccessLayer<SubmissionMail.Table>
        private let context: any DatabaseContext

        public init(context: any DatabaseContext) {
            self.context = context
            self.formAccessLayer = .init(context: context)
            self.mailAccessLayer = .init(context: context)
        }

        public func list() async throws -> Form.List.Output {
            let forms = try await formAccessLayer.select(
                as: Form.Table.List.self
            ) {
                $0.order(by: \.name).order(by: \.id)
            }

            var items: [Form.List.Output.Item] = []
            for form in forms {
                let fieldRows =
                    try await FormField.AccessLayer(
                        connection: context.connection
                    )
                    .list(formId: form.id)
                let fields = try fieldRows.map { row in
                    let model = try row.asDomain
                    return Form.Field(model: model)
                }
                let mailRows = try await mailAccessLayer.select(
                    as: SubmissionMail.Table.List.self
                ) {
                    $0.where(\.formId, equals: form.id).order(by: \.id)
                }
                let mails = try mailRows.map { row in
                    Form.Mail(
                        model: SubmissionMail.Model(
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
                    )
                }
                let model = Form.Model(
                    id: form.id,
                    key: form.key,
                    name: form.name,
                    successMessage: form.successMessage,
                    failureMessage: form.failureMessage,
                    redirectUrl: form.redirectUrl,
                    createdAt: form.createdAt,
                    updatedAt: form.updatedAt
                )
                items.append(.init(model: model, fields: fields, mails: mails))
            }

            return .init(items: items)
        }
    }
}
