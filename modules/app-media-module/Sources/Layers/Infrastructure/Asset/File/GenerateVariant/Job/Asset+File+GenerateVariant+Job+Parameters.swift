public import Jobs
public import MediaModule

extension Asset.File.GenerateVariant.Job {
    public struct Parameters: JobParameters {
        public static let jobName = "media_generate_variant"

        public let assetId: String

        public init(assetId: String) {
            self.assetId = assetId
        }
    }
}
