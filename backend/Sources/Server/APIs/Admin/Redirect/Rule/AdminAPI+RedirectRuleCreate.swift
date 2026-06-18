import AdminOpenAPI
import RedirectApplication
import Application

extension AdminAPI {

    /// Create redirect rule
    /*
     curl -i -X 'POST' \
        'http://127.0.0.1:8080/api/v1/admin/redirect/rules' \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -d '{"source":"/old","destination":"/new","statusCode":301,"notes":"legacy"}'
    */
    func redirectRuleCreate(
        _ input: Operations.RedirectRuleCreate.Input
    ) async throws -> Operations.RedirectRuleCreate.Output {

        let body: Components.Schemas.RedirectRuleCreateSchema
        switch input.body {
        case let .json(value):
            body = value
        }

        let useCase = modules.redirect.makeAddRule()
        let subject = try await CurrentSubject.require()
        let result = try await useCase.execute(
            subject: subject,
            input: .init(
                source: body.source,
                destination: body.destination,
                statusCode: body.statusCode,
                notes: body.notes ?? ""
            )
        )

        return .created(
            .init(
                body: .json(map(result))
            )
        )
    }
}
