import AdminOpenAPI
import RedirectApplication
import Application

extension AdminAPI {

    func redirectRuleUpdate(
        _ input: Operations.RedirectRuleUpdate.Input
    ) async throws -> Operations.RedirectRuleUpdate.Output {
        let body: Components.Schemas.RedirectRuleCreateSchema
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
