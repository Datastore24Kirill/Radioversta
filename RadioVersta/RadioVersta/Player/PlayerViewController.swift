//
//  PlayerViewController.swift
//  
//
//  Created by Кирилл Ковыршин on 11.06.2020.
//

import UIKit
import FRadioPlayer
import MarqueeLabel
import AVFoundation
import MediaPlayer
import SDWebImage


class PlayerViewController: UIViewController, FRadioPlayerDelegate {
   
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var nameLabel: MarqueeLabel!
    @IBOutlet weak var activiteIndicator: UIActivityIndicatorView!
    
    let player = FRadioPlayer.shared
    
    var currentArtist = "-"
    var currentTitle = "-"
    var currentImage: URL?
    
    @objc func checkButton() {
        if player.isPlaying {
           twoPostion()
        } else {
            firstPostion()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.delegate = self
        player.radioURL = URL(string: "http://92.63.97.12:8000/radio")
        player.isAutoPlay = false
        player.enableArtwork = true
        player.artworkSize = 100
        disableButton()
//        activiteIndicator.alpha = 0
        nameLabel.text = ""
        
        setupNowPlayingInfoCenter()
        NotificationCenter.default.addObserver(self, selector: #selector(checkButton), name: NSNotification.Name(rawValue: "UPDATESTATE"), object: nil)
        
        
//        player.togglePlaying()
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
//        }
        
    }
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        print("STATE: \(state.description)")
        switch state {
        case .error:
            print("error")
        case .loading:
            activiteIndicator.alpha = 1
            activiteIndicator.startAnimating()
            disableButton()
        case .loadingFinished:
            activiteIndicator.stopAnimating()
           activiteIndicator.alpha = 0
            firstPostion()
        case .readyToPlay:
            break
        case .urlNotSet:
            break
        }
       }
       
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        print("PLAYBACK STATE \(state.description)")
    }
    
    //Изменение Название песни и артиста
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        let songs = "\(artistName ?? "") - \(trackName ?? "")"
        currentArtist = artistName ?? "-"
        currentTitle = trackName ?? "-"
        print(songs)
        nameLabel.text = songs + "     "
        self.updateNowPlayingInfoCenter()
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        print("ARTWORK URL \(artworkURL)")
        currentImage = artworkURL
        self.updateNowPlayingInfoCenter()
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        playButton.isUserInteractionEnabled = false
        playButton.alpha = 0.5
        stopButton.isUserInteractionEnabled = true
        stopButton.alpha = 1.0
        player.play()
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        playButton.isUserInteractionEnabled = true
        playButton.alpha = 1.0
        stopButton.isUserInteractionEnabled = false
        stopButton.alpha = 0.5
        player.stop()
    }
    
    func disableButton() {
        playButton.isUserInteractionEnabled = false
        playButton.alpha = 0.5
        stopButton.isUserInteractionEnabled = false
        stopButton.alpha = 0.5
    }
    
    func firstPostion() {
        playButton.isUserInteractionEnabled = true
        playButton.alpha = 1.0
        stopButton.isUserInteractionEnabled = false
        stopButton.alpha = 0.5
    }
    
    func twoPostion() {
        playButton.isUserInteractionEnabled = false
        playButton.alpha = 0.5
        stopButton.isUserInteractionEnabled = true
        stopButton.alpha = 1.0
    }
    

    private func setupNowPlayingInfoCenter() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        MPRemoteCommandCenter.shared().playCommand.addTarget {event in
            self.playButtonAction(UIView())
            
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget {event in
            self.stopButtonAction(UIView())
            return .success
        }
        
    }
    
    
    private func updateNowPlayingInfoCenter(artwork: UIImage? = nil) {
        
        if let currentImage = currentImage {
           
            SDWebImageDownloader.shared.downloadImage(with: currentImage) { (image, data, error, finished) in
                if finished {
                    self.updateNowPlayingInfoCenter(artwork: image)
                }
            }
        }
   
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: currentTitle,
            MPMediaItemPropertyArtist: currentArtist
        ]
        if let artwork = artwork {
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: artwork.size, requestHandler: { (size) -> UIImage in
                    return artwork
            })
        }
    }
    


}
