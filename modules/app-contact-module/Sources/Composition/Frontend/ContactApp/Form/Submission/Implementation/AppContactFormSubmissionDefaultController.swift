import ContactAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AppContactFormSubmissionDefaultController:
    AppContactFormSubmissionController
{

    func submit(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let formId = try context.requiredParameter("formId")
        let form = try await request.decode(
            as: AppContactFormSubmissionForm.self,
            context: context
        )
        let response = try await context.contactApplicationAPI()
            .withOpenAPIRepositoryErrorMapping { client in
                try await client.appContactFormSubmission(
                    path: .init(contactFormId: formId),
                    body: .json(
                        .init(
                            values: .init(additionalProperties: form.values)
                        )
                    )
                )
            }
        guard case .created(let value) = response else {
            throw HTTPError(.badRequest)
        }
        let redirectURL = try value.body.json.redirectUrl
        return Response(
            status: .seeOther,
            headers: [
                .location: redirectURL ?? request.headers[.referer] ?? "/"
            ]
        )
    }
}
