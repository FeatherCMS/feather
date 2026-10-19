public import ContactAdminAPI
import ContactApplication
import FeatherApplication
import FeatherModuleKit

extension AdminAPIGateway {
    public func contactFieldGet(
        _ input: Operations.ContactFieldGet.Input
    ) async throws -> Operations.ContactFieldGet.Output {
        let result = try await self.useCases.makeGetFormField()
            .execute(
                subject: try await CurrentSubject.require(),
                input: .init(id: input.path.formFieldId, formId: nil)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
