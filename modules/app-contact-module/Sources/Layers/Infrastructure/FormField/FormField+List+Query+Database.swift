public import ContactApplication
import ContactDomain
public import ContactModule
import FeatherDBAL
public import FeatherInfrastructure

extension FormField.List.Query {
    public struct Database: Interface {
        private let context: any DatabaseContext
        private let formAccessLayer: DatabaseAccessLayer<Form.Table>
        private let fieldAccessLayer: DatabaseAccessLayer<FormField.Table>

        public init(context: any DatabaseContext) {
            self.context = context
            self.formAccessLayer = .init(context: context)
            self.fieldAccessLayer = .init(context: context)
        }

        public func list(input: FormField.List.Input) async throws
            -> FormField.List.Output
        {
            if input.isUnassigned {
                let rows = try await FormField.AccessLayer(
                    connection: context.connection
                )
                .listUnassigned()
                let models = try rows.map { try $0.asDomain }
                return .init(items: models.map { .init(model: $0) })
            }

            if let formKey = input.formKey {
                guard
                    let form = try await formAccessLayer.selectFirst(
                        by: \.key,
                        equals: formKey
                    )
                else {
                    return .init(items: [])
                }
                let rows = try await FormField.AccessLayer(
                    connection: context.connection
                )
                .list(formId: form.id)
                let models = try rows.map { try $0.asDomain }
                return .init(items: models.map { .init(model: $0) })
            }

            if let formId = input.formId {
                let rows = try await FormField.AccessLayer(
                    connection: context.connection
                )
                .list(formId: formId)
                let models = try rows.map { try $0.asDomain }
                return .init(items: models.map { .init(model: $0) })
            }

            let rows = try await fieldAccessLayer.select(
                as: FormField.Table.List.self
            ) {
                $0.order(by: \.id)
            }
            let models = try rows.map {
                try $0.asDomain(formId: "", position: 0)
            }
            return .init(items: models.map { .init(model: $0) })
        }
    }
}
