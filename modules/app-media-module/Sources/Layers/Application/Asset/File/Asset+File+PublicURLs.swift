public import FeatherDomain
import Foundation

public func mediaAssetPublicURL(
    id: String,
    `extension`: String,
    objectKeyGenerator: any ObjectKeyGenerator
) throws -> String {
    let prefix = try objectKeyGenerator.generate(from: id)
    let key = "original.\(`extension`)"
    return "/public/\(prefix)/\(encodedPath(key))"
}

public func mediaVariantPublicURL(
    assetId: String,
    variantKey: String,
    `extension`: String,
    objectKeyGenerator: any ObjectKeyGenerator
) throws -> String {
    let prefix = try objectKeyGenerator.generate(from: assetId)
    let key = "variants/\(variantKey).\(`extension`)"
    return "/public/\(prefix)/\(encodedPath(key))"
}

private func encodedPath(_ value: String) -> String {
    var allowed = CharacterSet.urlPathAllowed
    allowed.remove(charactersIn: "%?#")
    return value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
}
