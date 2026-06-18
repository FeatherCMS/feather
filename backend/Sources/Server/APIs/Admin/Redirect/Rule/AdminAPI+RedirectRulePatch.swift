import AdminOpenAPI
import RedirectApplication
import Application

extension AdminAPI {

    func redirectRulePatch(
        _ input: Operations.RedirectRulePatch.Input
    ) async throws -> Operations.RedirectRulePatch.Output {
        let body: Components.Schemas.RedirectRulePatchSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.redirect.makeEditRule()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                id: input.path.redirectRuleId,
                source: body.source,
                destination: body.destination,
                statusCode: body.statusCode,
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
