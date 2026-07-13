import AppOpenAPI
import Hummingbird

struct AppContactFormSubmissionDefaultController: AppContactFormSubmissionController {

    func submit(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let formId = try context.requiredParameter("formId")
        let form = try await request.decode(
            as: AppContactFormSubmissionForm.self,
            context: context
        )
        let response = try await context.applicationAPI().withOpenAPIRepositoryErrorMapping { client in
            try await client.appContactFormSubmission(
                path: .init(contactFormId: formId),
                body: .json(.init(
                    values: .init(additionalProperties: form.values)
                ))
            )
        }
        guard case .created = response else {
            throw HTTPError(.badRequest)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: request.headers[.referer] ?? "/"
            ]
        )
    }
}
