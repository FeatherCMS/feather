public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
import Foundation

extension FormField.Detail.Query {
    public struct Database: Interface {
        private let context: any DatabaseContext
        private let accessLayer: DatabaseAccessLayer<FormField.Table>

        public init(context: any DatabaseContext) {
            self.context = context
            self.accessLayer = .init(context: context)
        }

        public func find(
            id: String,
            formId: String?
        ) async throws -> FormField.Detail.Output {
            if let formId {
                guard
                    let row =
                        try await FormField.AccessLayer(
                            connection: context.connection
                        )
                        .find(id: id, formId: formId)
                else {
                    throw QueryError.notFound
                }
                guard let type = FormField.Model.ItemType(rawValue: row.type)
                else {
                    throw QueryError(
                        reason: .database,
                        logMessage:
                            "Invalid contact form field type: \(row.type)",
                        userFriendlyMessage:
                            "Unable to read the contact form field."
                    )
                }

                return .init(
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
            }

            guard
                let row = try await accessLayer.selectFirst(
                    by: \.id,
                    equals: id
                )
            else {
                throw QueryError.notFound
            }
            guard let type = FormField.Model.ItemType(rawValue: row.type) else {
                throw QueryError(
                    reason: .database,
                    logMessage: "Invalid contact form field type: \(row.type)",
                    userFriendlyMessage:
                        "Unable to read the contact form field."
                )
            }
            let allowedValues = try JSONDecoder()
                .decode(
                    [FormField.Model.Option].self,
                    from: Data(row.allowedValues.utf8)
                )

            return .init(
                id: row.id,
                formId: "",
                key: row.key,
                type: type,
                label: row.label,
                allowedValues: allowedValues,
                isRequired: row.isRequired,
                position: 0,
                createdAt: row.createdAt,
                updatedAt: row.updatedAt
            )
        }
    }
}
