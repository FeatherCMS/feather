import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import MediaDomain

public struct TableSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let variantRepository = MediaVariantDatabaseRepository(context: context)
        let processorRepository = MediaVariantProcessorDatabaseRepository(
            context: context
        )

        let variant: MediaVariant
        if var existing = try await variantRepository.list()
            .first(where: { $0.key == "preview" })
        {
            existing.name = "Preview"
            existing.isRequired = true
            existing.isActive = true
            variant = try await variantRepository.update(existing)
        }
        else {
            variant = try await variantRepository.insert(
                MediaVariant.create(
                    key: "preview",
                    name: "Preview",
                    isRequired: true,
                    isActive: true
                )
            )
        }

        let coverVariant: MediaVariant
        if var existing = try await variantRepository.list()
            .first(where: { $0.key == "cover" })
        {
            existing.name = "Cover"
            existing.isRequired = false
            existing.isActive = true
            coverVariant = try await variantRepository.update(existing)
        }
        else {
            coverVariant = try await variantRepository.insert(
                MediaVariant.create(
                    key: "cover",
                    name: "Cover",
                    isRequired: false,
                    isActive: true
                )
            )
        }

        let definitions: [(name: String, extensions: String, command: String)] =
            [
                (
                    "ImageMagick",
                    "png,jpg,jpeg,bmp",
                    "magick -define jpeg:size=512x512 {input.fullname} -filter Triangle -resize 256x256^ -gravity center -extent 256x256 -strip -quality 82 -define webp:method=3 {output.dirname}/{output.basename}.webp"
                ),
                (
                    "Ghostscript",
                    "pdf",
                    "gs -dSAFER -dBATCH -dNOPAUSE -dNOPROMPT -sDEVICE=pngalpha -r300 -dFirstPage=1 -dLastPage=1 -dUseCropBox -dFIXEDMEDIA -dPDFFitPage -g256x256 -sOutputFile=\"{output.dirname}/{output.basename}.png\" \"{input.fullname}\""
                ),
                (
                    "FFmpeg",
                    "mp4,mov,avi",
                    "ffmpeg -y -ss 00:00:01 -i \"{input.fullname}\" -frames:v 1 -vf \"scale=256:256:force_original_aspect_ratio=decrease,pad=256:256:(ow-iw)/2:(oh-ih)/2\" \"{output.dirname}/{output.basename}.png\""
                ),
            ]

        let existingProcessors = try await processorRepository.list(
            variantId: variant.id
        )
        for definition in definitions {
            if var existing = existingProcessors.first(where: {
                $0.name == definition.name
            }) {
                existing.matchExtensions = definition.extensions
                existing.commandTemplate = definition.command
                existing.isActive = true
                _ = try await processorRepository.update(existing)
            }
            else {
                _ = try await processorRepository.insert(
                    MediaVariantProcessor.create(
                        variantId: variant.id,
                        name: definition.name,
                        matchExtensions: definition.extensions,
                        commandTemplate: definition.command,
                        isActive: true
                    )
                )
            }
        }

        let coverDefinitions:
            [(name: String, extensions: String, command: String)] =
                [
                    (
                        "ImageMagick",
                        "png,jpg,jpeg,bmp",
                        "magick -define jpeg:size=2560x1280 {input.fullname} -filter Triangle -resize 1920x960^ -gravity center -extent 1920x960 -strip -quality 82 -define webp:method=3 {output.dirname}/{output.basename}.webp"
                    ),
                    (
                        "FFmpeg",
                        "mp4,mov,avi",
                        "ffmpeg -y -ss 00:00:01 -i \"{input.fullname}\" -frames:v 1 -vf \"scale=1920:960:force_original_aspect_ratio=increase,crop=1920:960\" \"{output.dirname}/{output.basename}.png\""
                    ),
                ]

        let existingCoverProcessors = try await processorRepository.list(
            variantId: coverVariant.id
        )
        for definition in coverDefinitions {
            if var existing = existingCoverProcessors.first(where: {
                $0.name == definition.name
            }) {
                existing.matchExtensions = definition.extensions
                existing.commandTemplate = definition.command
                existing.isActive = true
                _ = try await processorRepository.update(existing)
            }
            else {
                _ = try await processorRepository.insert(
                    MediaVariantProcessor.create(
                        variantId: coverVariant.id,
                        name: definition.name,
                        matchExtensions: definition.extensions,
                        commandTemplate: definition.command,
                        isActive: true
                    )
                )
            }
        }
    }
}
