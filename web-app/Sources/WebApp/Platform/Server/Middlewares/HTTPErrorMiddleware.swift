//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 05. 26..
//

import Hummingbird

struct HTTPErrorMiddleware: RouterMiddleware {

    func handle(
        _ request: Request,
        context: AppRequestContext,
        next: (Request, AppRequestContext) async throws -> Response
    ) async throws -> HummingbirdCore.Response {
        do {
            return try await next(request, context)
        }
        catch let error as HTTPError {
            switch error.status {
            case .notFound:
                let renderEngine = DefaultRenderingEngine(
                    publicOrigins: AppEnvironmentStore.current.publicOrigins
                )
                let htmlResponse = renderEngine.renderPage(
                    request: request,
                    title: "Page not found - Feather CMS",
                    description: "The requested page could not be found.",
                    imagePath: "images/puppy.png",
                    content: AppNotFoundPage()
                )
                return try HTMLResponse(
                    content: htmlResponse.content,
                    status: .notFound
                )
                .response(from: request, context: context)
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
