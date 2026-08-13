import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin
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
        next: @concurrent (Request, AppRequestContext) async throws -> Response
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
