//
//  ViewController.swift
//  LikeAnim
//
//  Created by DHN0195 on 2021/03/04.
//

import UIKit
import Lottie
class ViewController: UIViewController {

    let animationView = AnimationView(name: "like")
    let colors: [UIColor] = [.red, .systemPink, .orange, .yellow, .green, .blue, .purple]
    
    var animationTimer: Timer?
    var direction: CGFloat = 0
    let toggleButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 200),
            animationView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toggleButton)
        NSLayoutConstraint.activate([
            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 50),
            toggleButton.widthAnchor.constraint(equalToConstant: 100),
            toggleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        toggleButton.layer.cornerRadius = 15
        toggleButton.layer.borderWidth = 1
        toggleButton.layer.borderColor = UIColor.black.cgColor
        toggleButton.setTitleColor(.black, for: .normal)
        toggleButton.backgroundColor = .white
        toggleButton.setTitle("start", for: .normal)
        toggleButton.setTitle("pause", for: .selected)
        toggleButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        
        view.backgroundColor = .white
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.alpha = 0
        animationView.transform = CGAffineTransform(scaleX: -5, y: -5)
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            guard self.toggleButton.isSelected else { return }
            let randomColor = self.colors[(0...self.colors.count-1).randomElement() ?? 0]
            let heart = CALayer()
            heart.backgroundColor = randomColor.cgColor
            heart.cornerRadius = 10 / 2
            heart.frame = CGRect(x: 0, y: -50, width: 10, height: 10)
            
            let randomX = CGFloat((0...Int(self.view.frame.width)).randomElement() ?? 0)
            let dropAnim = CABasicAnimation(keyPath: "position")
            
            dropAnim.fromValue = CGPoint(x: randomX, y: 0)
            dropAnim.toValue = CGPoint(x: randomX + self.direction, y: self.view.frame.height)
            dropAnim.duration = 2
            heart.add(dropAnim, forKey: nil)
            self.view.layer.addSublayer(heart)
        })
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    private func startAnim() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.5) {
            self.animationView.alpha = 1
            self.animationView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            self.animationView.play()
        }
    }
    
    private func pauseAnim() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0) {
            self.animationView.alpha = 0
            self.animationView.transform = CGAffineTransform(scaleX: 0, y: 0)
        } completion: { _ in
            self.animationView.pause()
        }
    }
    
    @objc private func tapButton() {
        toggleButton.isSelected = !toggleButton.isSelected
        if toggleButton.isSelected {
            startAnim()
        } else {
            pauseAnim()
        }
    }
    
    @objc private func pan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let point = recognizer.translation(in: view)
            direction = point.x
        case .cancelled, .ended:
            direction = 0
        default: break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
}

