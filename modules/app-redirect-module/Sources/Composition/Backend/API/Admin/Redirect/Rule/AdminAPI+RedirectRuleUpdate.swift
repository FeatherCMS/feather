import FeatherApplication
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication
import RedirectDomain

extension RedirectBackend {

    public func redirectRuleUpdate(
        _ input: Operations.RedirectRuleUpdate.Input
    ) async throws -> Operations.RedirectRuleUpdate.Output {
        let body: Components.Schemas.RedirectRuleCreateSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.makeEditRule()
        let subject = try await CurrentSubject.require()
        guard let statusCode = Rule.StatusCode(rawValue: body.statusCode) else {
            throw Rule.Error.invalidStatusCode
        }
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.redirectRuleId,
                source: body.source,
                destination: body.destination,
                statusCode: statusCode,
                notes: body.notes
            )
        )

        return .ok(
            .init(
                body: .json(map(result))
            )
        )
    }
}
