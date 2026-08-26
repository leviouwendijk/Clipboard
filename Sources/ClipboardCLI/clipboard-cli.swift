import Arguments
import Clipboard
import Foundation

@main
enum ClipboardCLIEntry {
    static func main() async {
        await ClipboardCommand.main()
    }
}

enum ClipboardCommand:
    ArgumentCommand
{
    static let name =
        "clipboard"

    static let defaultChild =
        Help.self

    static let children:
        [ArgumentCommandType] =
            [
                Help.self,
                Read.self,
                Write.self,
            ]

    enum Help:
        RunnableArgumentCommand
    {
        static let name =
            "help"

        static func run(
            _ invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            print(
                ArgumentHelpRenderer()
                    .render(
                        command:
                            try ClipboardCommand
                                .spec()
                    )
            )
        }
    }

    enum Read:
        BoundArgumentCommand
    {
        typealias Options =
            ReadOptions

        static let name =
            "read"

        static func run(
            _ options: ReadOptions,
            invocation: ParsedInvocation
        ) async throws {
            _ = invocation

            let channel =
                ClipboardCommand.channel(
                    register:
                        options.register
                )

            guard let text =
                channel.read()
            else {
                throw ClipboardCLIError
                    .emptyChannel(
                        ClipboardCommand
                            .channelLabel(
                                register:
                                    options.register
                            )
                    )
            }

            if options.copy {
                guard options.register != nil else {
                    return
                }

                guard Clipboard.system.write(
                    text
                ) else {
                    throw ClipboardCLIError
                        .writeFailed(
                            "system clipboard"
                        )
                }

                return
            }

            ClipboardCommand.writeStandardOutput(
                text
            )
        }
    }

    enum Write:
        RunnableArgumentCommand
    {
        static let name =
            "write"

        static func components() throws
            -> [CommandComponentLowerable]
        {
            [
                arg(
                    "text",
                    as: String.self,
                    arity: .optional,
                    help:
                        "Text to write. When omitted, UTF-8 text is read from stdin."
                ),
                opt(
                    "register",
                    short: "r",
                    as: String.self,
                    help:
                        "Write to the named clipboard register instead of the system clipboard."
                ),
            ]
        }

        static func run(
            _ invocation: ParsedInvocation
        ) async throws {
            let supplied =
                try invocation.value(
                    "text",
                    as: String.self
                )

            let register =
                try invocation.value(
                    "register",
                    as: String.self
                )

            let text: String

            if let supplied {
                text =
                    supplied
            } else {
                let data =
                    FileHandle
                        .standardInput
                        .readDataToEndOfFile()

                guard let decoded =
                    String(
                        data: data,
                        encoding: .utf8
                    )
                else {
                    throw ClipboardCLIError
                        .invalidUTF8
                }

                text =
                    decoded
            }

            let channel =
                ClipboardCommand.channel(
                    register:
                        register
                )

            guard channel.write(
                text
            ) else {
                throw ClipboardCLIError
                    .writeFailed(
                        ClipboardCommand
                            .channelLabel(
                                register:
                                    register
                            )
                    )
            }
        }
    }
}

struct ReadOptions:
    ArgumentGroup
{
    @Opt(
        "register",
        short: "r",
        help:
            "Read from the named clipboard register instead of the system clipboard."
    )
    var register: String?

    @Flag(
        "copy",
        help:
            "Copy the read value into the system clipboard instead of writing it to stdout."
    )
    var copy: Bool

    init() {}
}

enum ClipboardCLIError:
    Error,
    LocalizedError
{
    case emptyChannel(String)
    case invalidUTF8
    case writeFailed(String)

    var errorDescription:
        String?
    {
        switch self {
        case .emptyChannel(let channel):
            "No text is available in \(channel)."

        case .invalidUTF8:
            "Standard input is not valid UTF-8 text."

        case .writeFailed(let channel):
            "Could not write text to \(channel)."
        }
    }
}

private extension ClipboardCommand {
    static func channel(
        register: String?
    ) -> Clipboard.Channel {
        guard let register else {
            return Clipboard.system
        }

        return Clipboard.register(
            register
        )
    }

    static func channelLabel(
        register: String?
    ) -> String {
        guard let register else {
            return "system clipboard"
        }

        return "register '\(register)'"
    }

    static func writeStandardOutput(
        _ text: String
    ) {
        FileHandle.standardOutput.write(
            Data(
                text.utf8
            )
        )
    }
}
