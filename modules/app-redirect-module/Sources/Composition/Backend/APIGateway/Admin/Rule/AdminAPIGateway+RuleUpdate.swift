import FeatherDomain
import FeatherModuleKit
public import RedirectAdminAPI
import RedirectApplication
import RedirectDomain
import RedirectModule

extension AdminAPIGateway {

    public func redirectRuleUpdate(
        _ input: Operations.RedirectRuleUpdate.Input
    ) async throws -> Operations.RedirectRuleUpdate.Output {
        let body: Components.Schemas.RedirectRuleCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditRule()
        let subject = try await CurrentSubject.require()
        guard let statusCode = Rule.StatusCode(rawValue: body.statusCode) else {
            throw Rule.Model.Error.invalidStatusCode
        }
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.redirectRuleId,
                source: .set(body.source),
                destination: .set(body.destination),
                statusCode: .set(statusCode),
                notes: body.notes.map(OptionalFieldChange.set) ?? .clear
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }

    func map(
        _ output: Rule.Edit.Output
    ) -> Components.Schemas.RedirectRuleDetailSchema {
        .init(
            id: output.id,
            source: output.source,
            destination: output.destination,
            statusCode: output.statusCode.rawValue,
            notes: output.notes
        )
    }
}
