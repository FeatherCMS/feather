public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherDBAL
public import FeatherInfrastructure

extension Submission.Detail.Query {
    public struct Database: Interface {
        private let formAccessLayer: DatabaseAccessLayer<Form.Table>
        private let submissionAccessLayer: DatabaseAccessLayer<Submission.Table>

        public init(context: any DatabaseContext) {
            self.formAccessLayer = .init(context: context)
            self.submissionAccessLayer = .init(context: context)
        }

        public func find(
            formKey: String,
            id: String
        ) async throws -> Submission.Detail.Output {
            guard
                let form = try await formAccessLayer.selectFirst(
                    by: \.key,
                    equals: formKey
                ),
                let submission = try await submissionAccessLayer.selectFirst(
                    by: \.id,
                    equals: id
                ),
                submission.formId == form.id
            else {
                throw QueryError.notFound
            }

            guard
                let status = Submission.Model.Status(
                    rawValue: submission.status
                )
            else {
                throw QueryError(
                    reason: .database,
                    logMessage:
                        "Invalid contact form submission status: \(submission.status)",
                    userFriendlyMessage:
                        "Unable to read the contact form submission."
                )
            }

            return .init(
                id: submission.id,
                formId: submission.formId,
                valuesJSON: submission.values,
                itemsSnapshotJSON: submission.itemsSnapshot,
                metadataJSON: submission.metadata,
                status: status,
                createdAt: submission.createdAt,
                updatedAt: submission.updatedAt
            )
        }
    }
}
