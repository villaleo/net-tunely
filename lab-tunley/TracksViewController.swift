//
//  ViewController.swift
//  lab-tunley
//
//  Created by Charlie Hieger on 12/1/22.
//

import UIKit

class TracksViewController: UIViewController, UITableViewDataSource {
    var tracks: [Track] = []
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "https://itunes.apple.com/search?term=bad+bunny&attribute=artistTerm&entity=song&media=music"
        let request = URLRequest(url: .init(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                fatalError("Network error: \(error.localizedDescription)")
            }
            guard let data = data else { print("Data is nil"); return }
            
            do {
                let decoder: JSONDecoder = .init()
                let dateFormatter: DateFormatter = .init()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let response = try decoder.decode(TrackResponse.self, from: data)
                let tracks = response.results;
                DispatchQueue.main.async {
                    self.tracks = tracks
                    self.tableView.reloadData()
                }
            } catch {
                fatalError("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let detailViewController = segue.destination as? DetailViewController
        {
            let track = tracks[indexPath.row]
            detailViewController.track = track
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        let track = tracks[indexPath.row]
        cell.configure(with: track)
        return cell
    }
}
