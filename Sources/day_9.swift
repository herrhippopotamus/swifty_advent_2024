class Day9: Day {
    var log: Bool
    init(log: Bool = false) {
        self.log = log
    }

    struct Point: Hashable, Equatable, CustomStringConvertible {
        let x: Int
        let y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    
        func move(to direction: Direction) -> Point {
            return switch direction {
                case .north: Point(x, y - 1)
                case .south: Point(x, y + 1)
                case .east: Point(x + 1, y)
                case .west: Point(x - 1, y)
            }
        }
        var description: String { "(\(x),\(y))" }
    }
    enum Direction: CaseIterable  {
        case north, south, east, west
    }
    class Path: CustomStringConvertible {
        let altitude: UInt8
        let pos: Point
        var nexts: [Path]? = nil
        var isValid: Bool

        init(pos: Point, altitude: UInt8) {
            self.altitude = altitude
            self.pos = pos
            self.isValid = altitude == 9
        }
        func addNext(_ p: Point) -> Path {
            if nexts == nil {
                nexts = []
            }
            let next = Path(pos: p, altitude: self.altitude + 1)
            nexts!.append(next)
            return next
        }
        var trailCount: Int {
            altitude == 9 ? 1 : (nexts?.map{$0.trailCount}.reduce(0, +) ?? 0)
        }
        // trailCount already "accidently" solved for part 1, just rename it...
        var rating: Int {
            trailCount
        }
        var peaks: [Point] {
            if altitude == 9 { return [self.pos] }
            var ps = Set<Point>()
            if let nexts = nexts {
                for next in nexts {
                    for peak in next.peaks {
                        ps.insert(peak)
                    }
                }
            }
            return Array(ps)
        }
        var score: Int {
            peaks.count
        }
        var description: String {
            "Path(pos: \(pos), score: \(score))"
        }
    }

    class Grid: CustomStringConvertible {
        let values: [[UInt8]]
        let dims: Point

        init(values: [[UInt8]]) {
            self.values = values
            self.dims = Point(values.count, values[0].count)
        }

        var startingPoints: [Point] {
            var pnts: [Point] = []
            for (i, row) in values.enumerated() {
                for (j, val) in row.enumerated() {
                    if val == 0 {
                        pnts.append(Point(i, j))
                    }
                }
            }
            return pnts
        }
        func paths() -> [Path] {
            var trails: [Path] = []
            for start in self.startingPoints {
                let trail = Path(pos: start, altitude: 0)
                nextPathSteps(path: trail)
                trails.append(trail)
            }
            return trails
        }
        func nextPathSteps(path: Path) {
            for dir in Direction.allCases {
                let nextPos = path.pos.move(to: dir)
                if let nextAlt = self.altitude(pos: nextPos) {
                    if nextAlt == path.altitude + 1 {
                        let nextPath = path.addNext(nextPos)
                        if nextPath.altitude < 9 {
                            nextPathSteps(path: nextPath)
                        }
                    }
                }
            }
            if path.nexts?.contains(where: {$0.isValid}) == true {
                path.isValid = true
            } else {
                path.nexts?.removeAll()
            }
            // remove invalid trails:
            var i = 0
            while i < (path.nexts?.count ?? 0) {
                if !path.nexts![i].isValid {
                    path.nexts!.remove(at: i)
                }else{
                    i += 1
                }
            }
        }
        func altitude(pos: Point) -> UInt8? {
            if pos.y >= 0 && pos.y < dims.y && pos.x >= 0 && pos.x < dims.x {
                return values[pos.x][pos.y]
            }
            return nil
        }

        var description: String {
            values.map{ line in line.map { String($0) }.joined(separator: "") }.joined(separator: "\n")
        }
    }

    func eval() -> (Int, Int) {
        let grid = parseGrid(puzzle_9)
        let paths = grid.paths()
        if log {
            print("paths: \(paths)")
            for p in paths {
                print(p)
            }
        }
        let part1 = paths.map{ $0.score }.reduce(0, +)
        let part2 = paths.map{ $0.rating }.reduce(0, +)

        return (part1, part2)
    }
    func parseGrid(_ puzzle: String) -> Grid {
        var grid: [[UInt8]] = []
        for line in puzzle.split(separator: "\n") {
            grid.append( line.compactMap{ $0.asciiValue }.map{ $0 - 48 } )
        }
        return Grid(values: grid)
    }
}

let puzzle_9 = """
210121012321234586543237650120901076540121001
101234985490147897890198701221812389430430012
567105676787458721209877654336765410321569123
498014785010969630118960165445898923210678234
309323494323874549823454278321080854100123945
211234515690123678989923329876571765987637876
110987601781010501677815410989432894543540345
021010532782323432596506901098126545652901276
012123445693437010487417892387087036761892987
323098530696598923300306103456592123890743210
014567621787127654211215296503431014125650309
329643452650034018987894387112321265034321478
498762167541005329876012379012450996543406567
567433098932116456705430498763567887456715458
016526187654327643212321567654654321019823309
327817656783298984103435433216789670321094215
438908943090125675678976124105894589452385434
567617812181034106789780045674583076581276123
106787801654323295610191230983012109690187012
245096998745016784327898101092103298781298432
332165432101565410678765432387654567654382321
456976541001274328769867211498565650103401450
697889034012389219654358300567656743212519567
787765121965476101011249401456549865435658498
657854320876210894320134562340134678321067019
548943013456367885012021076543221589801354323
038765412387478976523256789601100499832231234
129914302198565985430143898702341300740140145
878801243089478876943232169219654211655657656
965760651078769217854321078348778902598748912
054450782369854308765010127651267143456732103
123321895451043219678098763410356012349801654
103456986032112008769123452345441078959798723
212387872149800123452101011096732163478760810
301095433458945654343000125687823454307451923
454346721567238769289210234776916543210312367
965239810123189378176321349885407892321208498
870125676034003210065443456790398901765089567
345676787165612349898652105381210340894176506
210985696278973656776789965450678256783215410
101974320161087298785649874367589109891006321
007876013232196105694234701298432098782107890
012565434983435234523105650165601105673456921
323476325876524321012023498074320234504305430
434789016789012010123110567789210343212214321
"""