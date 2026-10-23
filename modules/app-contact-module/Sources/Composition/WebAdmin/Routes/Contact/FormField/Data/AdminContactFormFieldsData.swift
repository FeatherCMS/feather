import ContactAdminAPI
import FeatherWebShared
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore

struct AdminContactFormFieldsData {
    private struct FormFieldsPayload: Encodable {
        struct Item: Encodable {
            let key: String
            let label: String
        }

        let items: [Item]
    }

    let environment: AppEnvironment

    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(ContactAdminRoutes.formFieldsDataRoute, use: get)
    }

    private func get(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let formKey = try context.requiredParameter("formKey")
        let client =
            API.Client(
                apiBaseURL: environment.apiBaseURL,
                requestContext: context
            )
            .client
        let result = try await client.contactFormGet(
            path: .init(contactFormKey: formKey)
        )

        switch result {
        case .ok(let response):
            let form = try response.body.json
            let payload = FormFieldsPayload(
                items: (form.items ?? [])
                    .map {
                        .init(key: $0.key, label: $0.label)
                    }
            )
            let data = try JSONEncoder().encode(payload)
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            return Response(
                status: .ok,
                headers: [.contentType: "application/json; charset=utf-8"],
                body: .init(byteBuffer: buffer)
            )
        case .notFound:
            return Response(status: .notFound)
        case .unauthorized:
            return Response(status: .unauthorized)
        case .forbidden:
            return Response(status: .forbidden)
        case .undocumented:
            return Response(status: .badGateway)
        }
    }
}
