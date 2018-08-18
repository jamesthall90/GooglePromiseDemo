//
//  UIImageExtensions.swift
//  SwifterSwift
//
//  Created by Omar Albeik on 8/6/16.
//  Copyright © 2016 SwifterSwift
//

#if canImport(UIKit)
import UIKit
import Accelerate

// MARK: - Properties
public extension UIImage {

	/// SwifterSwift: Size in bytes of UIImage
	public var bytesSize: Int {
		return UIImageJPEGRepresentation(self, 1)?.count ?? 0
	}

	/// SwifterSwift: Size in kilo bytes of UIImage
	public var kilobytesSize: Int {
		return bytesSize / 1024
	}

	/// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
	public var original: UIImage {
		return withRenderingMode(.alwaysOriginal)
	}

	/// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
	public var template: UIImage {
		return withRenderingMode(.alwaysTemplate)
	}

}

// MARK: - Methods
public extension UIImage {

	/// SwifterSwift: Compressed UIImage from original UIImage.
	///
	/// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
	/// - Returns: optional UIImage (if applicable).
	public func compressed(quality: CGFloat = 0.5) -> UIImage? {
		guard let data = compressedData(quality: quality) else { return nil }
		return UIImage(data: data)
	}

	/// SwifterSwift: Compressed UIImage data from original UIImage.
	///
	/// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
	/// - Returns: optional Data (if applicable).
	public func compressedData(quality: CGFloat = 0.5) -> Data? {
		return UIImageJPEGRepresentation(self, quality)
	}

	/// SwifterSwift: UIImage Cropped to CGRect.
	///
	/// - Parameter rect: CGRect to crop UIImage to.
	/// - Returns: cropped UIImage
	public func cropped(to rect: CGRect) -> UIImage {
		guard rect.size.height < size.height && rect.size.height < size.height else { return self }
		guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
		return UIImage(cgImage: image)
	}

	/// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
	///
	/// - Parameters:
	///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
	///   - orientation: optional UIImage orientation (default is nil).
	/// - Returns: optional scaled UIImage (if applicable).
    public func scaled(toHeight: CGFloat, opaque: Bool = false, with orientation: UIImageOrientation? = nil) -> UIImage? {
		let scale = toHeight / size.height
		let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, scale)
		draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}

	/// SwifterSwift: UIImage scaled to width with respect to aspect ratio.
	///
	/// - Parameters:
	///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
	///   - orientation: optional UIImage orientation (default is nil).
	/// - Returns: optional scaled UIImage (if applicable).
	public func scaled(toWidth: CGFloat, opaque: Bool = false, with orientation: UIImageOrientation? = nil) -> UIImage? {
		let scale = toWidth / size.width
		let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, scale)
		draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}

	/// SwifterSwift: UIImage filled with color
	///
	/// - Parameter color: color to fill image with.
	/// - Returns: UIImage filled with given color.
	public func filled(withColor color: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		color.setFill()
		guard let context = UIGraphicsGetCurrentContext() else { return self }

		context.translateBy(x: 0, y: size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		context.setBlendMode(CGBlendMode.normal)

		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		guard let mask = self.cgImage else { return self }
		context.clip(to: rect, mask: mask)
		context.fill(rect)

		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return newImage
	}

	/// SwifterSwift: UIImage tinted with color
	///
	/// - Parameters:
	///   - color: color to tint image with.
	///   - blendMode: how to blend the tint
	/// - Returns: UIImage tinted with given color.
	public func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
		let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		let context = UIGraphicsGetCurrentContext()
		context!.clip(to: drawRect, mask: cgImage!)
		color.setFill()
		UIRectFill(drawRect)
		draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return tintedImage!
	}

    /// SwifterSwift: UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}

// MARK: - Initializers
public extension UIImage {

	/// SwifterSwift: Create UIImage from color and size.
	///
	/// - Parameters:
	///   - color: image fill color.
	///   - size: image size.
	public convenience init(color: UIColor, size: CGSize) {
		UIGraphicsBeginImageContextWithOptions(size, false, 1)
		color.setFill()
		UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
		guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
			self.init()
			return
		}
		UIGraphicsEndImageContext()
		guard let aCgImage = image.cgImage else {
			self.init()
			return
		}
		self.init(cgImage: aCgImage)
	}
    
    class func imageWithSolidColor(_ color: UIColor?, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        if color != nil {
            color!.setFill()
        } else {
            UIColor.black.setFill()
        }
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }

    class func imageFromScreen() -> UIImage {
        let keyWindow = UIApplication.shared.keyWindow
        let rect = keyWindow?.bounds
        UIGraphicsBeginImageContextWithOptions((rect?.size)!, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        keyWindow?.layer.render(in: context!)
        let capturedScreen = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedScreen!;
    }

    public func applyBlurWithRadius(_ blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage? = nil) -> UIImage? {
        // Check pre-conditions.
        if (size.width < 1 || size.height < 1) {
            print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
            return nil
        }
        if self.cgImage == nil {
            print("*** error: image must be backed by a CGImage: \(self)")
            return nil
        }
        if maskImage != nil && maskImage!.cgImage == nil {
            print("*** error: maskImage must be backed by a CGImage: \(String(describing: maskImage))")
            return nil
        }
        
        let __FLT_EPSILON__ = CGFloat(Float.ulpOfOne)
        let screenScale = UIScreen.main.scale
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage = self
        
        let hasBlur = blurRadius > __FLT_EPSILON__
        let hasSaturationChange = fabs(saturationDeltaFactor - 1.0) > __FLT_EPSILON__
        
        if hasBlur || hasSaturationChange {
            func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
                let data = context.data
                let width = vImagePixelCount(context.width)
                let height = vImagePixelCount(context.height)
                let rowBytes = context.bytesPerRow
                
                return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectInContext = UIGraphicsGetCurrentContext()
            
            effectInContext?.scaleBy(x: 1.0, y: -1.0)
            effectInContext?.translateBy(x: 0, y: -size.height)
            effectInContext?.draw(self.cgImage!, in: imageRect)
            
            var effectInBuffer = createEffectBuffer(effectInContext!)
            
            
            UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
            let effectOutContext = UIGraphicsGetCurrentContext()
            
            var effectOutBuffer = createEffectBuffer(effectOutContext!)
            
            
            if hasBlur {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                
                let inputRadius = blurRadius * screenScale
                let calculateRadius = floor(inputRadius * 3.0 * CGFloat(sqrt(2 * Double.pi)) / 4 + 0.5)
                var radius = UInt32(calculateRadius)
                if radius % 2 != 1 {
                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
                }
                
                let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
            }
            
            var effectImageBuffersAreSwapped = false
            
            if hasSaturationChange {
                let s: CGFloat = saturationDeltaFactor
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,  1
                ]
                
                let divisor: CGFloat = 256
                let matrixSize = floatingPointSaturationMatrix.count
                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
                
                for i in 0...matrixSize-1 {
                    saturationMatrix[i] = Int16(round(floatingPointSaturationMatrix[i] * divisor))
                }
                
                if hasBlur {
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                } else {
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped {
                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
            }
            
            UIGraphicsEndImageContext()
        }
        
        // Set up output context.
        UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
        let outputContext = UIGraphicsGetCurrentContext()
        outputContext?.scaleBy(x: 1.0, y: -1.0)
        outputContext?.translateBy(x: 0, y: -size.height)
        
        // Draw base image.
        outputContext?.draw(self.cgImage!, in: imageRect)
        
        // Draw effect image.
        if hasBlur {
            outputContext?.saveGState()
            if let image = maskImage {
                outputContext?.clip(to: imageRect, mask: image.cgImage!);
            }
            outputContext?.draw(effectImage.cgImage!, in: imageRect)
            outputContext?.restoreGState()
        }
        
        // Add in color tint.
        if let color = tintColor {
            outputContext?.saveGState()
            outputContext?.setFillColor(color.cgColor)
            outputContext?.fill(imageRect)
            outputContext?.restoreGState()
        }
        
        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    }
#endif
