import Foundation

var runtimeAvg = Double(0)
let runs = 1000
for run in 0..<runs {
    let start = Date()
    let (d10, d11) = day1()
    let elapsed = Date().timeIntervalSince(start)
    runtimeAvg += Double(elapsed)
    print(String(format: "run[%d / %d]: Day 1 - result 1: %d, result 2: %d - elapsed: %.3f ms", run, runs, d10, d11, elapsed * 1000))
}

print(String(format: "Elapsed on average: %.3f ms", runtimeAvg / Double(runs) * 1000))
