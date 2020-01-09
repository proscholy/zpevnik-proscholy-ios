//
//  LaunchViewController.swift
//  Zpevnik
//
//  Created by Patrik Dobiáš on 23/07/2019.
//  Copyright © 2019 Patrik Dobiáš. All rights reserved.
//

import UIKit

class LaunchVC: ViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView: UIImageView
        if #available(iOS 13, *) {
            imageView = UIImageView(image: UIImage(named: "background"))
        } else {
            imageView = UIImageView(image: UIImage(named: UserSettings.darkMode ? "backgroundDark" : "background"))
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let titleImageView: UIImageView = {
        let imageView: UIImageView
        if #available(iOS 13, *) {
            imageView = UIImageView(image: UIImage(named: "homeScreenTitle"))
        } else {
            imageView = UIImageView(image: UIImage(named: UserSettings.darkMode ? "homeScreenTitleDark" : "homeScreenTitle"))
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let progressInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .center
        label.text = "Příprava písní"
        
        return label
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13, *) {
            indicator = UIActivityIndicatorView()
        } else {
            indicator = UIActivityIndicatorView(style: UserSettings.darkMode ? .white : .gray)
        }
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(backgroundImageView)
        
        view.addSubview(titleImageView)
        view.addSubview(loadingIndicator)
        view.addSubview(progressInfoLabel)
        
        let views = [
            "titleImageView": titleImageView,
            "loadingIndicator": loadingIndicator,
            "progressInfoLabel": progressInfoLabel
        ]
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[backgroundImageView]|", metrics: nil, views: ["backgroundImageView": backgroundImageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[backgroundImageView]|", metrics: nil, views: ["backgroundImageView": backgroundImageView]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleImageView]-|", metrics: nil, views: ["titleImageView": titleImageView,]))
        view.addConstraint(NSLayoutConstraint(item: loadingIndicator, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: progressInfoLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: loadingIndicator, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleImageView]", metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[loadingIndicator]-[progressInfoLabel]", metrics: nil, views: views))
        view.addConstraint(NSLayoutConstraint(item: titleImageView, attribute: .width, relatedBy: .equal, toItem: titleImageView, attribute: .height, multiplier: 505.0 / 153.0, constant: 0))
        
        loadingIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateSongLyrics()
    }
    
    private func updateSongLyrics() {
        DownloadService.updateSongs({ progressInfo in
            DispatchQueue.main.async {
                self.progressInfoLabel.text = progressInfo
            }
        }) {
            DispatchQueue.main.async {
                let vc = TabBarController()
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        }
    }
}
