import Application

public struct WebRouteDetail: DTO {
    public let referenceType: String
    public let referenceID: String
    public let slug: String

    public init(
        referenceType: String,
        referenceID: String,
        slug: String
    ) {
        self.referenceType = referenceType
        self.referenceID = referenceID
        self.slug = slug
    }
}
