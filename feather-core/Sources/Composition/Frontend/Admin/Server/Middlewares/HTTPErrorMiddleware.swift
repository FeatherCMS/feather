import Hummingbird

public struct HTTPErrorMiddleware<Context: RequestContext>: RouterMiddleware {

    public init() {}

    public func handle(
        _ request: Request,
        context: Context,
        next: @concurrent (Request, Context) async throws -> Response
    ) async throws -> HummingbirdCore.Response {
        do {
            return try await next(request, context)
        }
        catch let error as HTTPError {
            switch error.status {
            case .notFound:
                return Response(
                    status: .notFound,
                    body: .init(byteBuffer: .init(string: "Not found"))
                )
            default:
                print("\(type(of: error))")
                print("\(error)")
                let message = error.body ?? error.status.description
                return Response(
                    status: error.status,
                    body: .init(
                        byteBuffer: .init(string: message)
                    )
                )
            }
        }
        catch let error as OpenAPIRepositoryError {
            print("\(type(of: error))")
            print("\(error)")
            return Response(
                status: error.httpStatus,
                body: .init(
                    byteBuffer: .init(string: error.errorDescription)
                )
            )
        }
        catch {
            print("\(type(of: error))")
            print("\(error)")
            return Response(
                status: .internalServerError,
                body: .init(
                    byteBuffer: .init(string: "Internal server error")
                )
            )
        }
    }
}
