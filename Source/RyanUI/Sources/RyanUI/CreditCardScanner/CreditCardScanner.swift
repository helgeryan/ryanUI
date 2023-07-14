//
//  CreditCardScanner.swift
//  
//
//  Created by Ryan Helgeson on 7/13/23.
//

import AVFoundation
import CoreImage
import UIKit
import Vision

public protocol CreditCardScannerDelegate {
    func didReceiveCreditCardInfo(_ creditCard: CreditCard)
}

@available(iOS 13.0, *)
public class CreditCardScanner: UIViewController {
    
    // MARK: - Private Properties
    private var creditCard = CreditCard(number: nil, cvv: nil, date: nil)
    private let captureSession = AVCaptureSession()
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer(session: self.captureSession)
        preview.videoGravity = .resizeAspect
        return preview
    }()

    private let device = AVCaptureDevice.default(for: .video)
    private var viewGuide: PartialTransparentView!
    private let videoOutput = AVCaptureVideoDataOutput()

    // MARK: - Public Properties
    var delegate: CreditCardScannerDelegate?
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hintBottomLabel: UILabel!
    @IBOutlet weak var hintTopLabel: UILabel!
    @IBOutlet weak var creditCardNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Initializers

    public init(delegate: CreditCardScannerDelegate) {
        self.delegate = delegate
        super.init(nibName: "CreditCardScanner", bundle: .module)
    }

    public class func getScanner(delegate: CreditCardScannerDelegate) -> UINavigationController {
        let viewScanner = CreditCardScanner(delegate: delegate)
        let navigation = UINavigationController(rootViewController: viewScanner)
        return navigation
    }

    required init?(coder: NSCoder) {
        super.init(nibName: "CreditCardScanner", bundle: .module)
    }
    
    deinit {
        stop()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    // MARK: - Setup
    private func setupCaptureSession() {
        addCameraInput()
        addPreviewLayer()
        addVideoOutput()
        addGestures()
    }

    private func addCameraInput() {
        guard let device = device else { return }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }

    private func addPreviewLayer() {
        view.layer.insertSublayer(previewLayer, at: 0)
    }

    private func addVideoOutput() {
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as NSString: NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "my.image.handling.queue"))
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else {
            return
        }
        connection.videoOrientation = .portrait
    }

    private func addGestures() {
        creditCardNumberLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearCardNumber)))
        cvvLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearCardCVV)))
        dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearCardDate)))
    }

    // MARK: - Actions
    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doSubmit(_ sender: Any) {
        delegate?.didReceiveCreditCardInfo(creditCard)
        stop()
        dismiss(animated: true, completion: nil)
    }

    @objc func clearCardNumber() {
        creditCardNumberLabel?.text = ""
        creditCard.number = nil
    }

    @objc func clearCardDate() {
        dateLabel?.text = ""
        creditCard.date = nil
    }

    @objc func clearCardCVV() {
        cvvLabel?.text = ""
        creditCard.cvv = nil
    }

    // MARK: - Completed process
    private func stop() {
        captureSession.stopRunning()
    }

    // MARK: - Payment detection
    private func handleObservedPaymentCard(in frame: CVImageBuffer) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.extractPaymentCardData(frame: frame)
        }
    }

    private func extractPaymentCardData(frame: CVImageBuffer) {
        let ciImage = CIImage(cvImageBuffer: frame)
        let widht = UIScreen.main.bounds.width - (UIScreen.main.bounds.width * 0.2)
        let height = widht - (widht * 0.45)
        let viewX = (UIScreen.main.bounds.width / 2) - (widht / 2)
        let viewY = (UIScreen.main.bounds.height / 2) - (height / 2) - 100 + height

        let resizeFilter = CIFilter(name: "CILanczosScaleTransform")!

        // Desired output size
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        // Compute scale and corrective aspect ratio
        let scale = targetSize.height / ciImage.extent.height
        let aspectRatio = targetSize.width / (ciImage.extent.width * scale)

        // Apply resizing
        resizeFilter.setValue(ciImage, forKey: kCIInputImageKey)
        resizeFilter.setValue(scale, forKey: kCIInputScaleKey)
        resizeFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        let outputImage = resizeFilter.outputImage

        let croppedImage = outputImage!.cropped(to: CGRect(x: viewX, y: viewY, width: widht, height: height))

        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false

        let stillImageRequestHandler = VNImageRequestHandler(ciImage: croppedImage, options: [:])
        try? stillImageRequestHandler.perform([request])

        guard let texts = request.results, texts.count > 0 else {
            // no text detected
            return
        }

        let arrayLines = texts.flatMap({ $0.topCandidates(20).map({ $0.string }) })

        for line in arrayLines {
            print("Trying to parse: \(line)")

            let trimmed = line.replacingOccurrences(of: " ", with: "")

            if parseCreditCardNumber(trimmed: trimmed, line: line) {
                continue
            } else if parseCreditCardCvv(trimmed: trimmed, line: line) {
                continue
            } else if parseCreditCardDate(trimmed: trimmed, line: line) {
               continue
            } else {
                let _ = parseCreditCardName(trimmed: trimmed, line: line)
            }
        }
    }
    
    func parseCreditCardNumber(trimmed: String, line: String) -> Bool {
        if creditCard.number == nil &&
            trimmed.count >= 15 &&
            trimmed.count <= 16 &&
            trimmed.isOnlyNumbers {
            creditCard.number = line
            DispatchQueue.main.async {
                self.creditCardNumberLabel?.text = line
                self.tapticFeedback()
            }
            return true
        }
        return false
    }
    
    
    func parseCreditCardCvv(trimmed: String, line: String) -> Bool {
        if creditCard.cvv == nil &&
            trimmed.count == 3 &&
            trimmed.isOnlyNumbers {
            creditCard.cvv = line
            DispatchQueue.main.async {
                self.cvvLabel?.text = line
                self.tapticFeedback()
            }
            return true
        }
        return false
    }
    
    func parseCreditCardDate(trimmed: String, line: String) -> Bool {
        if creditCard.date == nil &&
            trimmed.count >= 5 && // 12/20
            trimmed.count <= 7 && // 12/2020
            trimmed.isDate {
            
            creditCard.date = line
            DispatchQueue.main.async {
                self.dateLabel?.text = line
                self.tapticFeedback()
            }
            return true
        }
        return false
    }
    
    func parseCreditCardName(trimmed: String, line: String) -> Bool {
        // Not used yet
        if creditCard.name == nil &&
            trimmed.count > 10 &&
            line.contains(" ") &&
            trimmed.isOnlyAlpha {
            
            creditCard.name = line
            return true
        }
        return false
    }

    private func tapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
@available(iOS 13.0, *)
extension CreditCardScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }

        handleObservedPaymentCard(in: frame)
    }
}
