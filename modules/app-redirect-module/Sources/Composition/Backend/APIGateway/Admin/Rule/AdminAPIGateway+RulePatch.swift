import FeatherApplication
import FeatherContracts
import RedirectAdminAPI
import RedirectApplication
import RedirectDomain
import RedirectContracts

extension AdminAPIGateway {

    public func redirectRulePatch(
        _ input: Operations.RedirectRulePatch.Input
    ) async throws -> Operations.RedirectRulePatch.Output {
        let body: Components.Schemas.RedirectRulePatchSchema
        switch input.body {
        case .json(let value):
            body = value
        }

        let useCase = self.useCases.makeEditRule()
        let subject = try await CurrentSubject.require()
        let statusCode = body.statusCode.flatMap(
            StatusCode.init(rawValue:)
        )
        guard body.statusCode == nil || statusCode != nil else {
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
