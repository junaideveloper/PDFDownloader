//
//  ViewController.swift
//  PDFDownloader
//
//  Created by Junaid TT on 12/09/2021.
//

import UIKit

class ViewController: UIViewController, URLSessionDelegate {
    var pdfURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func download_tapped(_ sender: Any) {
        
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        
        let url_seesion = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        let downloadTask = url_seesion.downloadTask(with: url)
        downloadTask.resume()
        
    }

}
extension ViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
            print("file has been saved to file manager")
            print(destinationURL)
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
