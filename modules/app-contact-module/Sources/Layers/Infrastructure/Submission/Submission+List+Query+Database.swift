public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherDBAL
public import FeatherInfrastructure

extension Submission.List.Query {
    public struct Database: Interface {
        private let formAccessLayer: DatabaseAccessLayer<Form.Table>
        private let submissionAccessLayer: DatabaseAccessLayer<Submission.Table>

        public init(context: any DatabaseContext) {
            self.formAccessLayer = .init(context: context)
            self.submissionAccessLayer = .init(context: context)
        }

        public func list(input: Submission.List.Input) async throws
            -> Submission.List.Output
        {
            guard
                let form = try await formAccessLayer.selectFirst(
                    by: \.key,
                    equals: input.formKey
                )
            else {
                throw QueryError.notFound
            }

            let rows = try await submissionAccessLayer.select(
                as: Submission.Table.List.self
            ) {
                $0.where(\.formId, equals: form.id)
                    .order(by: \.createdAt, .descending)
                    .order(by: \.id, .descending)
            }
            let items = try rows.map { row in
                guard
                    let status = Submission.Model.Status(rawValue: row.status)
                else {
                    throw QueryError(
                        reason: .database,
                        logMessage:
                            "Invalid contact form submission status: \(row.status)",
                        userFriendlyMessage:
                            "Unable to read contact form submissions."
                    )
                }
                let model = Submission.Model(
                    id: row.id,
                    formId: row.formId,
                    valuesJSON: row.values,
                    itemsSnapshotJSON: row.itemsSnapshot,
                    metadataJSON: row.metadata,
                    status: status,
                    createdAt: row.createdAt,
                    updatedAt: row.updatedAt
                )
                return Submission.List.Output.Item(model: model)
            }
            return .init(items: items)
        }
    }
}
