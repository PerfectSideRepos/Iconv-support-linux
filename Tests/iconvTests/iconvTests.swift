import XCTest
@testable import iconv

class iconvTests: XCTestCase {
    func testExample() {
        let sz = 255
        let bytes:[UInt8] = [0xd6, 0xd0, 0xb9, 0xfa, 0x0a]
        let cd = iconv_open("UTF-8", "GB2312")
        let src = UnsafeMutablePointer<Int8>.allocate(capacity: sz)
        let tag = UnsafeMutablePointer<Int8>.allocate(capacity: sz)
        memset(src, 0, sz)
        memset(tag, 0, sz)
        let _ = bytes.withUnsafeBufferPointer { memcpy(src, $0.baseAddress!, bytes.count) }

        var pa: UnsafeMutablePointer<Int8>? = src
        var pb: UnsafeMutablePointer<Int8>? = tag

        var szi: size_t = 4
        var szo: size_t = sz
        let r = iconv(cd, &pa, &szi, &pb, &szo)
        XCTAssertNotEqual(r, -1)
        guard let str = String(validatingUTF8: tag) else {
          XCTFail("validating")
          return
        }
        print(str)
        XCTAssertEqual(str, "中国")
        src.deinitialize()
        tag.deinitialize()
        iconv_close(cd)
    }


    static var allTests : [(String, (iconvTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
