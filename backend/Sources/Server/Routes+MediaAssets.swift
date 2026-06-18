import FeatherDatabase
import Foundation
import Hummingbird
import Infrastructure
import NIOCore

private func mediaContentType(
    for type: String
) -> String {
    let normalized = type.trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()
    let extensionLike =
        normalized.contains("/")
        ? (normalized.split(separator: "/").last.map(String.init) ?? normalized)
        : normalized

    switch extensionLike {
    case "jpg", "jpeg":
        return "image/jpeg"
    case "png":
        return "image/png"
    case "gif":
        return "image/gif"
    case "webp":
        return "image/webp"
    case "mp4":
        return "video/mp4"
    case "mov":
        return "video/quicktime"
    case "webm":
        return "video/webm"
    default:
        return "application/octet-stream"
    }
}

private func mediaStorageKeyExtension(
    _ storageKey: String
) -> String? {
    let fileName =
        storageKey.split(separator: "/").last.map(String.init) ?? storageKey
    guard let dotIndex = fileName.lastIndex(of: "."),
        dotIndex < fileName.index(before: fileName.endIndex)
    else {
        return nil
    }
    let ext = String(fileName[fileName.index(after: dotIndex)...]).lowercased()
    return ext.isEmpty ? nil : ext
}

func registerMediaAssetRoutes(
    on router: Router<AppRequestContext>,
    modules: AppModules
) {
    router.get("/media/assets/**") { request, _ in
        guard
            let storageKey = extractMediaRouteStorageKey(
                from: request.uri.path,
                routePrefix: "/media/assets/"
            )
        else {
            return Response(status: .badRequest)
        }

        do {
            let result = try await modules.media.readOriginalAssetFile(
                storageKey: storageKey
            )
            var buffer = ByteBufferAllocator()
                .buffer(capacity: result.data.count)
            buffer.writeBytes(result.data)
            return Response(
                status: .ok,
                headers: [
                    .contentType: mediaContentType(for: result.type),
                    .cacheControl: "public, max-age=31536000, immutable",
                ],
                body: .init(byteBuffer: buffer)
            )
        }
        catch let error as RepositoryError
        where error.reason == .database(.notFound) {
            return Response(status: .notFound)
        }
        catch {
            return Response(status: .internalServerError)
        }
    }

    router.get("/media/variants/**") { request, _ in
        guard
            let storageKey = extractMediaRouteStorageKey(
                from: request.uri.path,
                routePrefix: "/media/variants/"
            )
        else {
            return Response(status: .badRequest)
        }

        do {
            let data = try await modules.media.readVariantFile(
                storageKey: storageKey
            )
            let ext = mediaStorageKeyExtension(storageKey) ?? ""
            var buffer = ByteBufferAllocator().buffer(capacity: data.count)
            buffer.writeBytes(data)
            return Response(
                status: .ok,
                headers: [
                    .contentType: mediaContentType(for: ext),
                    .cacheControl: "public, max-age=31536000, immutable",
                ],
                body: .init(byteBuffer: buffer)
            )
        }
        catch {
            return Response(status: .notFound)
        }
    }
}

private func extractMediaRouteStorageKey(
    from requestPath: String,
    routePrefix: String
) -> String? {
    guard requestPath.hasPrefix(routePrefix) else {
        return nil
    }
    let suffix = String(requestPath.dropFirst(routePrefix.count))
    guard !suffix.isEmpty else {
        return nil
    }
    return suffix.removingPercentEncoding ?? suffix
}
