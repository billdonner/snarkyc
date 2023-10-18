
//
//  main.swift
//  snarky
//
//  Created by bill donner on 10/9/23.
//
import Foundation

import ArgumentParser
import q20kshare

func generatePumperStuff(_ inputTextFile: URL, _ substitutions: [[String]]) throws  -> String  {
  let template0:String = try String(contentsOf: inputTextFile)
  var output = ""
  for row in 0..<substitutions.count {
    var line = template0.replacingOccurrences(of: "$GENERATED", with: "\(Date())")
    for col in 0..<substitutions[row].count {
      let el = substitutions[row][col]
      line = line.replacingOccurrences(of: "$\(col)", with: el)
    }
    output  += line + "***"
  }
  return output
}
func convertJSONToOldFormat(_ x:[Topic])->[[String ]]{
  x.map{ [$0.name,$0.subject,String($0.per)]}
}

func parseJSON(_ url: URL) throws -> [[String]] {
  // Load substitutions JSON file,throw out all of the metadata for now
  let data = try Data(contentsOf: url)
  let decoded = try JSONDecoder().decode(TopicData.self, from:data)
  let x =  convertJSONToOldFormat(decoded.topics)
  return x
}


struct Snarky: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Generate A Script of ChatGPT Prompts From One Template and JSON File of Topic Data",
    discussion: "The template file is any file with $0 - $9 symbols that are replaced by values supplied in the JSON File.\nEach line of the JSON generates another prompt appended to the output script.\n",
    version: "0.5.0")
  
  @Argument(  help: "The template file URL")
  var inputTextFileURL: String
  
  @Argument(  help: "The topic data JSON file URL")
  var substitutionsJSONFileURL: String
  
  @Option(name: .shortAndLong, help: "The optional output text file URL of prompts; otherwise outputs to the console (Between_0_1.txt)")
  var output: String?
  
  @Option(name: .shortAndLong, help: "Make output file name unique")
  var unique: Bool = false
  
  func generateFileName(prefixPath:String) -> String {
    if unique {
      let date = Date()
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyyMMdd_HHmmss"
      let dateString = formatter.string(from: date)
      return prefixPath + "_" + dateString + ".txt"
    } else {
      return prefixPath +  ".txt"
    }
  }
  
  func snarky_essence(_ substitutionsJSONFile: URL,
                      _ inputTextFile: URL) throws {
    let outputTextFile = output != nil ? URL(string: output!) : nil
    let substitutions = Array(try parseJSON(substitutionsJSONFile))
    
    let fallback = URL(string:"~/snarky")!
    let primary = outputTextFile?.deletingPathExtension()
    let outputFileName = generateFileName(prefixPath: "\(primary ?? fallback)")
    let outputFilesString =  try generatePumperStuff(inputTextFile, substitutions)
    if output != nil {
      if let outputFile  = URL(string:outputFileName) {
        do {
          print("Writing \(substitutions.count) prompts to \(outputFileName).")
          try outputFilesString.write(to:outputFile,atomically:true, encoding: .utf8)
          print("Generated \(outputFilesString.count) bytes of prompts files.")
        }
        catch {
          print("could not write to \(outputFileName), \(error)")
        }
      }
    } else {
      print(outputFilesString)
    }
  }
  func run() throws {
    guard let inputTextFile = URL(string: inputTextFileURL),
          let substitutionsJSONFile = URL(string: substitutionsJSONFileURL) else {
      throw ValidationError("Input file URLs must be valid")
    }
    let start_time = Date()
    print("Command Line: \(CommandLine.arguments) \n")
    try snarky_essence(substitutionsJSONFile, inputTextFile)
    let elapsed = Date().timeIntervalSince(start_time)
    print("Elapsed \(elapsed) secs")
  }
}

Snarky.main()
