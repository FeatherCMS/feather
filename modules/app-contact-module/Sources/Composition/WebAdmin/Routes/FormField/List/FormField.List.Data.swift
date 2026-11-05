import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore

extension FormField.List {
    struct Data {
        private struct Payload: Encodable {
            struct Item: Encodable {
                let key: String
                let label: String
            }

            let items: [Item]
        }

        let environment: AppEnvironment
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let formKey = try context.requiredParameter("formKey")
            let api = API.Client(
                environment: environment,
                requestContext: context
            )
            let repository = Repository.OpenAPI(api: api)

            do {
                let payload = Payload(
                    items:
                        try await repository
                        .formFieldOptions(formKey: formKey)
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
            }
            catch let error as OpenAPIRepositoryError {
                return Response(status: error.httpStatus)
            }
        }
    }
}
