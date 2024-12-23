import Foundation

class AsciiSplitter: Sequence, IteratorProtocol {
    var start = 0
    let splitter: UInt8
    let buffer: [UInt8]
    var i = 0

    init(split str: String, by char: UInt8) {
        self.splitter = char
        buffer = Array(str.utf8)
    }

    // parses a string from the current pos <start> until <i>
    // and advances start accordingly.
    func parseStr() -> String {
        defer {
            start = i + 1
        }
        return String(
            decoding: buffer[start..<i],
            as: UTF8.self
        )
    }
    
    // iterator implementation
    func next() -> String? {
        while i < buffer.endIndex {
            let c = buffer[i]
            if c == splitter {
                if start < i {
                    return parseStr()
                }
                
            }
            i += 1
        }
        if start < buffer.endIndex {
            return parseStr()
        }
        return nil
    }
}