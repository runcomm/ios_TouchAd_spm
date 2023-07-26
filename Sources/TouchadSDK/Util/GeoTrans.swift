//
//  GeoTrans.swift
//  TouchadSDK
//
//  Created by shimtaewoo on 2021/02/05.
//

import UIKit

public class GeoTransPoint: NSObject {

    var x: Double = 0
    var y: Double = 0
    var z: Double = 0
    /**
     *
     */
    public override init() {
        
    }
    /**
     * @param x
     * @param y
     */
    public init(_ x: Double, _ y: Double) {
        
        self.x = x
        self.y = y
        self.z = 0
    }
    /**
     * @param x
     * @param y
     * @param y
     */
    public func GeoTransPoint(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = 0
    }
    
    public func getX() -> Double {
        return x
    }
    
    public func getY() -> Double {
        return y
    }


}

public class GeoTrans {
    
    static let sharedInstance = GeoTrans()
    
    public static var GEO : Int = 0
    public static var KATEC : Int = 1
    public static var TM : Int = 2
    public static var GRS80 : Int = 3
    
    private static var m_Ind = [Double](repeating: 0, count: 3)
    private static var m_Es = [Double](repeating: 0, count: 3)
    private static var m_Esp = [Double](repeating: 0, count: 3)
    private static var src_m = [Double](repeating: 0, count: 3)
    private static var dst_m = [Double](repeating: 0, count: 3)

    private static var EPSLN : Double = 0.0000000001
    private static var m_arMajor = [Double](repeating: 0, count: 3)
    private static var m_arMinor = [Double](repeating: 0, count: 3)

    private static var m_arScaleFactor = [Double](repeating: 0, count: 3)
    private static var m_arLonCenter = [Double](repeating: 0, count: 3)
    private static var m_arLatCenter = [Double](repeating: 0, count: 3)
    private static var m_arFalseNorthing = [Double](repeating: 0, count: 3)
    private static var m_arFalseEasting = [Double](repeating: 0, count: 3)
    
    private static var datum_params = [Double](repeating: 0, count: 3)
    
    public init() {
        
        GeoTrans.m_arScaleFactor[GeoTrans.GEO] = 1
        GeoTrans.m_arLonCenter[GeoTrans.GEO] = 0.0
        GeoTrans.m_arLatCenter[GeoTrans.GEO] = 0.0
        GeoTrans.m_arFalseNorthing[GeoTrans.GEO] = 0.0
        GeoTrans.m_arFalseEasting[GeoTrans.GEO] = 0.0
        GeoTrans.m_arMajor[GeoTrans.GEO] = 6378137.0
        GeoTrans.m_arMinor[GeoTrans.GEO] = 6356752.3142

        GeoTrans.m_arScaleFactor[GeoTrans.KATEC] = 0.9999//0.9999
        //GeoTrans.m_arLonCenter[GeoTrans.KATEC] = 2.22529479629277 // 127.5
        GeoTrans.m_arLonCenter[GeoTrans.KATEC] = 2.23402144255274 // 128
        GeoTrans.m_arLatCenter[GeoTrans.KATEC] = 0.663225115757845
        GeoTrans.m_arFalseNorthing[GeoTrans.KATEC] = 600000.0
        GeoTrans.m_arFalseEasting[GeoTrans.KATEC] = 400000.0
        GeoTrans.m_arMajor[GeoTrans.KATEC] = 6377397.155
        GeoTrans.m_arMinor[GeoTrans.KATEC] = 6356078.9633422494
        
        GeoTrans.m_arScaleFactor[GeoTrans.TM] = 1.0
        //this.m_arLonCenter[GeoTrans.TM] = 2.21656815003280 // 127
        GeoTrans.m_arLonCenter[GeoTrans.TM] = 2.21661859489671 // 127.+10.485 minute
        GeoTrans.m_arLatCenter[GeoTrans.TM] = 0.663225115757845
        GeoTrans.m_arFalseNorthing[GeoTrans.TM] = 500000.0
        GeoTrans.m_arFalseEasting[GeoTrans.TM] = 200000.0
        GeoTrans.m_arMajor[GeoTrans.TM] = 6377397.155
        GeoTrans.m_arMinor[GeoTrans.TM] = 6356078.9633422494

        GeoTrans.datum_params[0] = -146.43
        GeoTrans.datum_params[1] = 507.89
        GeoTrans.datum_params[2] = 681.46

        var tmp : Double = GeoTrans.m_arMinor[GeoTrans.GEO] / GeoTrans.m_arMajor[GeoTrans.GEO]
        GeoTrans.m_Es[GeoTrans.GEO] = 1.0 - tmp * tmp
        GeoTrans.m_Esp[GeoTrans.GEO] = GeoTrans.m_Es[GeoTrans.GEO] / (1.0 - GeoTrans.m_Es[GeoTrans.GEO])

        if (GeoTrans.m_Es[GeoTrans.GEO] < 0.00001) {
            GeoTrans.m_Ind[GeoTrans.GEO] = 1.0
        } else {
            GeoTrans.m_Ind[GeoTrans.GEO] = 0.0
        }
        
        tmp = GeoTrans.m_arMinor[GeoTrans.KATEC] / GeoTrans.m_arMajor[GeoTrans.KATEC]
        GeoTrans.m_Es[GeoTrans.KATEC] = 1.0 - tmp * tmp
        GeoTrans.m_Esp[GeoTrans.KATEC] = GeoTrans.m_Es[GeoTrans.KATEC] / (1.0 - GeoTrans.m_Es[GeoTrans.KATEC])
        
        if (GeoTrans.m_Es[GeoTrans.KATEC] < 0.00001) {
            GeoTrans.m_Ind[GeoTrans.KATEC] = 1.0
        } else {
            GeoTrans.m_Ind[GeoTrans.KATEC] = 0.0
        }
        
        tmp = GeoTrans.m_arMinor[GeoTrans.TM] / GeoTrans.m_arMajor[GeoTrans.TM]
        GeoTrans.m_Es[GeoTrans.TM] = 1.0 - tmp * tmp
        GeoTrans.m_Esp[GeoTrans.TM] = GeoTrans.m_Es[GeoTrans.TM] / (1.0 - GeoTrans.m_Es[GeoTrans.TM])

        if (GeoTrans.m_Es[GeoTrans.TM] < 0.00001) {
            GeoTrans.m_Ind[GeoTrans.TM] = 1.0
        } else {
            GeoTrans.m_Ind[GeoTrans.TM] = 0.0
        }
        
        GeoTrans.src_m[GeoTrans.GEO] = GeoTrans.m_arMajor[GeoTrans.GEO] * GeoTrans.mlfn(GeoTrans.e0fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.e1fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.e2fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.e3fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.m_arLatCenter[GeoTrans.GEO])
        GeoTrans.dst_m[GeoTrans.GEO] = GeoTrans.m_arMajor[GeoTrans.GEO] * GeoTrans.mlfn(GeoTrans.e0fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.e1fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.e2fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.e3fn(GeoTrans.m_Es[GeoTrans.GEO]), GeoTrans.m_arLatCenter[GeoTrans.GEO])
        GeoTrans.src_m[GeoTrans.KATEC] = GeoTrans.m_arMajor[GeoTrans.KATEC] * GeoTrans.mlfn(GeoTrans.e0fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.e1fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.e2fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.e3fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.m_arLatCenter[GeoTrans.KATEC])
        GeoTrans.dst_m[GeoTrans.KATEC] = GeoTrans.m_arMajor[GeoTrans.KATEC] * GeoTrans.mlfn(GeoTrans.e0fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.e1fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.e2fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.e3fn(GeoTrans.m_Es[GeoTrans.KATEC]), GeoTrans.m_arLatCenter[GeoTrans.KATEC])
        GeoTrans.src_m[GeoTrans.TM] = GeoTrans.m_arMajor[GeoTrans.TM] * GeoTrans.mlfn(GeoTrans.e0fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.e1fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.e2fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.e3fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.m_arLatCenter[GeoTrans.TM])
        GeoTrans.dst_m[GeoTrans.TM] = GeoTrans.m_arMajor[GeoTrans.TM] * GeoTrans.mlfn(GeoTrans.e0fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.e1fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.e2fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.e3fn(GeoTrans.m_Es[GeoTrans.TM]), GeoTrans.m_arLatCenter[GeoTrans.TM])
        
    }
    
    private static func D2R(_ degree : Double) -> Double {
        return degree * Double.pi / 180.0
    }

    private static func R2D(_ radian : Double) -> Double {
        return radian * 180.0 / Double.pi
    }

    private static func e0fn(_ x : Double) -> Double {
        return 1.0 - 0.25 * x * (1.0 + x / 16.0 * (3.0 + 1.25 * x))
    }

    private static func e1fn(_ x : Double) -> Double {
        return 0.375 * x * (1.0 + 0.25 * x * (1.0 + 0.46875 * x))
    }

    private static func e2fn(_ x : Double) -> Double {
        return 0.05859375 * x * x * (1.0 + 0.75 * x)
    }

    private static func e3fn(_ x : Double) -> Double {
        return x * x * x * (35.0 / 3072.0)
    }

    private static func mlfn(_ e0 : Double, _ e1 : Double, _ e2 : Double, _ e3 : Double, _ phi : Double) -> Double {
        return e0 * phi - e1 * sin(2.0 * phi) + e2 * sin(4.0 * phi) - e3 * sin(6.0 * phi)
    }

    private static func asinz(_ value : Double) -> Double {
        if (abs(value) > 1.0)
        {
            let ret = value > 0 ? 1.0 : -1.0
            return ret
        }
        else
        {
            return asin(value)
        }
    }
    
    
    public func convert(_ srctype : Int, _ dsttype : Int, _ in_pt : GeoTransPoint) -> GeoTransPoint {
        var tmpPt = GeoTransPoint()
        var out_pt = GeoTransPoint()

        if (srctype == GeoTrans.GEO) {
            tmpPt.x = GeoTrans.D2R(in_pt.x)
            tmpPt.y = GeoTrans.D2R(in_pt.y)
        } else {
            GeoTrans.tm2geo(srctype, in_pt, tmpPt)
        }

        if (dsttype ==  GeoTrans.GEO) {
            out_pt.x = GeoTrans.R2D(tmpPt.x)
            out_pt.y = GeoTrans.R2D(tmpPt.y)
        } else {
            GeoTrans.geo2tm(dsttype, tmpPt, out_pt)
            //out_pt.x = round(out_pt.x)
            //out_pt.y = round(out_pt.y)
        }

        return out_pt
    }
    
    public static func geo2tm(_ dsttype : Int, _ in_pt : GeoTransPoint, _ out_pt : GeoTransPoint) {
        var x : Double
        var y : Double
        
        GeoTrans.transform(GeoTrans.GEO, dsttype, in_pt)
        var delta_lon : Double = in_pt.x - m_arLonCenter[dsttype]
        var sin_phi : Double = sin(in_pt.y)
        var cos_phi : Double = cos(in_pt.y)

        if (m_Ind[dsttype] != 0) {
            var b : Double = cos_phi * sin(delta_lon)

            if ((abs(abs(b) - 1.0)) < GeoTrans.EPSLN) {
                //Log.d("���Ѵ� ����")
                //System.out.println("���Ѵ� ����")
            }
        } else {
            var b : Double = 0
            x = 0.5 * m_arMajor[dsttype] * m_arScaleFactor[dsttype] * log((1.0 + b) / (1.0 - b))
            var con : Double = acos(cos_phi * cos(delta_lon) / sqrt(1.0 - b * b))

            if (in_pt.y < 0) {
                con = con * -1
                y = m_arMajor[dsttype] * m_arScaleFactor[dsttype] * (con - m_arLatCenter[dsttype])
            }
        }

        let al : Double = cos_phi * delta_lon
        let als : Double = al * al
        let c : Double = m_Esp[dsttype] * cos_phi * cos_phi
        let tq : Double = tan(in_pt.y)
        let t : Double = tq * tq
        let con : Double = 1.0 - m_Es[dsttype] * sin_phi * sin_phi
        let n : Double = m_arMajor[dsttype] / sqrt(con)
        let ml : Double = m_arMajor[dsttype] * GeoTrans.mlfn(GeoTrans.e0fn(m_Es[dsttype]), GeoTrans.e1fn(m_Es[dsttype]), GeoTrans.e2fn(m_Es[dsttype]), GeoTrans.e3fn(m_Es[dsttype]), in_pt.y)

        out_pt.x = m_arScaleFactor[dsttype] * n * al * (1.0 + als / 6.0 * (1.0 - t + c + als / 20.0 * (5.0 - 18.0 * t + t * t + 72.0 * c - 58.0 * m_Esp[dsttype]))) + m_arFalseEasting[dsttype]
        out_pt.y = m_arScaleFactor[dsttype] * (ml - dst_m[dsttype] + n * tq * (als * (0.5 + als / 24.0 * (5.0 - t + 9.0 * c + 4.0 * c * c + als / 30.0 * (61.0 - 58.0 * t + t * t + 600.0 * c - 330.0 * m_Esp[dsttype]))))) + m_arFalseNorthing[dsttype]
    }


    public static func tm2geo(_ srctype : Int, _ in_pt : GeoTransPoint, _ out_pt : GeoTransPoint) {
        var tmpPt = GeoTransPoint(in_pt.getX(), in_pt.getY())
        var max_iter : Int = 6

        if (m_Ind[srctype] != 0) {
            let f : Double = exp(in_pt.x / (m_arMajor[srctype] * m_arScaleFactor[srctype]))
            let g : Double = 0.5 * (f - 1.0 / f)
            let temp : Double = m_arLatCenter[srctype] + tmpPt.y / (m_arMajor[srctype] * m_arScaleFactor[srctype])
            let h : Double = cos(temp)
            let con : Double = sqrt((1.0 - h * h) / (1.0 + g * g))
            out_pt.y = asinz(con)

            if (temp < 0)
            {
                out_pt.y *= -1
            }

            if ((g == 0) && (h == 0)) {
                out_pt.x = m_arLonCenter[srctype]
            } else {
                out_pt.x = atan(g / h) + m_arLonCenter[srctype]
            }
        }

        tmpPt.x -= m_arFalseEasting[srctype]
        tmpPt.y -= m_arFalseNorthing[srctype]

        var con : Double = (src_m[srctype] + tmpPt.y / m_arScaleFactor[srctype]) / m_arMajor[srctype]
        var phi : Double = con

        var i : Int = 0

        while true {
            var delta_Phi : Double = ((con + GeoTrans.e1fn(m_Es[srctype]) * sin(2.0 * phi) - GeoTrans.e2fn(m_Es[srctype]) * sin(4.0 * phi) + GeoTrans.e3fn(m_Es[srctype]) * sin(6.0 * phi)) / GeoTrans.e0fn(m_Es[srctype])) - phi
            phi = phi + delta_Phi

            if (abs(delta_Phi) <= GeoTrans.EPSLN)
            {
                break
            }
            

            if (i >= max_iter) {
                //Log.d("���Ѵ� ����")
                //System.out.println("���Ѵ� ����")
                break
            }

            i+=1
        }

        if (abs(phi) < (Double.pi / 2)) {
            let sin_phi : Double = sin(phi)
            let cos_phi : Double = cos(phi)
            let tan_phi : Double = tan(phi)
            let c : Double = m_Esp[srctype] * cos_phi * cos_phi
            let cs : Double = c * c
            let t : Double = tan_phi * tan_phi
            let ts : Double = t * t
            let cont : Double = 1.0 - m_Es[srctype] * sin_phi * sin_phi
            let n : Double = m_arMajor[srctype] / sqrt(cont)
            let r : Double = n * (1.0 - m_Es[srctype]) / cont
            let d : Double = tmpPt.x / (n * m_arScaleFactor[srctype])
            let ds : Double = d * d
            out_pt.y = phi - (n * tan_phi * ds / r) * (0.5 - ds / 24.0 * (5.0 + 3.0 * t + 10.0 * c - 4.0 * cs - 9.0 * m_Esp[srctype] - ds / 30.0 * (61.0 + 90.0 * t + 298.0 * c + 45.0 * ts - 252.0 * m_Esp[srctype] - 3.0 * cs)))
            out_pt.x = m_arLonCenter[srctype] + (d * (1.0 - ds / 6.0 * (1.0 + 2.0 * t + c - ds / 20.0 * (5.0 - 2.0 * c + 28.0 * t - 3.0 * cs + 8.0 * m_Esp[srctype] + 24.0 * ts))) / cos_phi)
        } else {
            out_pt.y = Double.pi * 0.5 * sin(tmpPt.y)
            out_pt.x = m_arLonCenter[srctype]
        }
        GeoTrans.transform(srctype, GeoTrans.GEO, out_pt)
    }
    
    
    public static func getDistancebyGeo(_ pt1 : GeoTransPoint, _ pt2 : GeoTransPoint) -> Double {
        let lat1 : Double = GeoTrans.D2R(pt1.y)
        let lon1 : Double = GeoTrans.D2R(pt1.x)
        let lat2 : Double = GeoTrans.D2R(pt2.y)
        let lon2 : Double = GeoTrans.D2R(pt2.x)

        let longitude : Double = lon2 - lon1
        let latitude : Double = lat2 - lat1

        let a : Double = pow(sin(latitude / 2.0), 2) + cos(lat1) * cos(lat2) * pow(sin(longitude / 2.0), 2)
        return 6376.5 * 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
    }

    public static func getDistancebyKatec(_ pt1 : GeoTransPoint, _ pt2 : GeoTransPoint) -> Double {
        let pt1 = GeoTrans.sharedInstance.convert(GeoTrans.KATEC, GeoTrans.GEO, pt1)
        let pt2 = GeoTrans.sharedInstance.convert(GeoTrans.KATEC, GeoTrans.GEO, pt2)

        return getDistancebyGeo(pt1, pt2)
    }
    
    public static func getDistancebyTm(_ pt1 : GeoTransPoint, _ pt2 : GeoTransPoint) -> Double {
        let pt1 = GeoTrans.sharedInstance.convert(GeoTrans.TM, GeoTrans.GEO, pt1)
        let pt2 = GeoTrans.sharedInstance.convert(GeoTrans.TM, GeoTrans.GEO, pt2)

        return getDistancebyGeo(pt1, pt2)
    }

    private static func getTimebySec(_ distance: Double) -> Int {
        return Int(round(3600 * distance / 4))
    }

    public static func getTimebyMin(_ distance: Double) -> Int {
        return Int(ceil(Double(getTimebySec(distance) / 60)))
    }

    /*
    Author:       Richard Greenwood rich@greenwoodmap.com
    License:      LGPL as per: http://www.gnu.org/copyleft/lesser.html
    */
    
    /**
     * convert between geodetic coordinates (longitude, latitude, height)
     * and gecentric coordinates (X, Y, Z)
     * ported from Proj 4.9.9 geocent.c
    */

    // following constants from geocent.c
    private static var HALF_PI : Double = 0.5 * Double.pi
    private static var COS_67P5 : Double  = 0.38268343236508977  /* cosine of 67.5 degrees */
    private static var AD_C : Double      = 1.0026000
    /* Toms region 1 constant */
    
    private static func transform(_ srctype : Int, _ dsttype : Int, _ point : GeoTransPoint) {
        if (srctype == dsttype)
        {
            return
        }
        
        if (srctype != 0 || dsttype != 0) {
            // Convert to geocentric coordinates.
            GeoTrans.geodetic_to_geocentric(srctype, point)
            
            // Convert between datums
            if (srctype != 0) {
                GeoTrans.geocentric_to_wgs84(point)
            }
            
            if (dsttype != 0) {
                GeoTrans.geocentric_from_wgs84(point)
            }
            
            // Convert back to geodetic coordinates
            GeoTrans.geocentric_to_geodetic(dsttype, point)
        }
    }

    private static func geodetic_to_geocentric (_ type : Int, _ p : GeoTransPoint) -> Bool {

    /*
     * The function Convert_Geodetic_To_Geocentric converts geodetic coordinates
     * (latitude, longitude, and height) to geocentric coordinates (X, Y, Z),
     * according to the current ellipsoid parameters.
     *
     *    Latitude  : Geodetic latitude in radians                     (input)
     *    Longitude : Geodetic longitude in radians                    (input)
     *    Height    : Geodetic height, in meters                       (input)
     *    X         : Calculated Geocentric X coordinate, in meters    (output)
     *    Y         : Calculated Geocentric Y coordinate, in meters    (output)
     *    Z         : Calculated Geocentric Z coordinate, in meters    (output)
     *
     */

        var Longitude : Double = p.x
        var Latitude : Double = p.y
        var Height : Double = p.z
        var X : Double  // output
        var Y : Double
        var Z : Double

        var Rn  : Double           /*  Earth radius at location  */
        var Sin_Lat : Double       /*  sin(Latitude)  */
        var Sin2_Lat : Double      /*  Square of sin(Latitude)  */
        var Cos_Lat : Double       /*  cos(Latitude)  */

      /*
      ** Don't blow up if Latitude is just a little out of the value
      ** range as it may just be a rounding issue.  Also removed longitude
      ** test, it should be wrapped by cos() and sin().  NFW for PROJ.4, Sep/2001.
      */
        if (Latitude < -GeoTrans.HALF_PI && Latitude > -1.001 * GeoTrans.HALF_PI )
        {
            Latitude = -GeoTrans.HALF_PI
        }
        else if (Latitude > GeoTrans.HALF_PI && Latitude < 1.001 * GeoTrans.HALF_PI )
        {
            Latitude = GeoTrans.HALF_PI
        }
        else if ((Latitude < -GeoTrans.HALF_PI) || (Latitude > GeoTrans.HALF_PI)) { /* Latitude out of range */
          return true
        }

      /* no errors */
        if (Longitude > Double.pi)
        {
            Longitude -= (2 * Double.pi)
        }
        Sin_Lat = sin(Latitude)
        Cos_Lat = cos(Latitude)
        Sin2_Lat = Sin_Lat * Sin_Lat
        Rn = m_arMajor[type] / (sqrt(1.0e0 - m_Es[type] * Sin2_Lat))
        X = (Rn + Height) * Cos_Lat * cos(Longitude)
        Y = (Rn + Height) * Cos_Lat * sin(Longitude)
        Z = ((Rn * (1 - m_Es[type])) + Height) * Sin_Lat

        p.x = X
        p.y = Y
        p.z = Z
        
        return false
    } // cs_geodetic_to_geocentric()


    /** Convert_Geocentric_To_Geodetic
     * The method used here is derived from 'An Improved Algorithm for
     * Geocentric to Geodetic Coordinate Conversion', by Ralph Toms, Feb 1996
     */
    private static func geocentric_to_geodetic (_ type : Int, _ p : GeoTransPoint) {

        var X: Double = p.x
        var Y: Double = p.y
        var Z: Double = p.z
        var Longitude: Double
        var Latitude: Double = 0.0
        var Height: Double

        var W: Double        /* distance from Z axis */
        var W2: Double       /* square of distance from Z axis */
        var T0: Double       /* initial estimate of vertical component */
        var T1: Double       /* corrected estimate of vertical component */
        var S0: Double       /* initial estimate of horizontal component */
        var S1: Double       /* corrected estimate of horizontal component */
        var Sin_B0: Double   /* sin(B0), B0 is estimate of Bowring aux doubleiable */
        var Sin3_B0: Double  /* cube of sin(B0) */
        var Cos_B0: Double   /* cos(B0) */
        var Sin_p1: Double   /* sin(phi1), phi1 is estimated latitude */
        var Cos_p1: Double   /* cos(phi1) */
        var Rn: Double       /* Earth radius at location */
        var Sum: Double      /* numerator of cos(phi1) */
        var At_Pole : Bool  /* indicates location is in polar region */

        At_Pole = false
        
        if (X != 0.0) {
          Longitude = atan2(Y,X)
        }
        else {
          if (Y > 0) {
            Longitude = GeoTrans.HALF_PI
          }
          else if (Y < 0) {
            Longitude = -GeoTrans.HALF_PI
          }
          else {
              At_Pole = true
              Longitude = 0.0
              if (Z > 0.0) {  /* north pole */
                Latitude = GeoTrans.HALF_PI
              }
              else if (Z < 0.0) {  /* south pole */
                Latitude = -GeoTrans.HALF_PI
              }
              else {  /* center of earth */
                Latitude = GeoTrans.HALF_PI
                  Height = -m_arMinor[type]
                  return
              }
          }
        }
        W2 = X*X + Y*Y
        W = sqrt(W2)
        T0 = Z * GeoTrans.AD_C
        S0 = sqrt(T0 * T0 + W2)
        Sin_B0 = T0 / S0
        Cos_B0 = W / S0
        Sin3_B0 = Sin_B0 * Sin_B0 * Sin_B0
        T1 = Z + m_arMinor[type] * m_Esp[type] * Sin3_B0
        Sum = W - m_arMajor[type] * m_Es[type] * Cos_B0 * Cos_B0 * Cos_B0
        S1 = sqrt(T1*T1 + Sum * Sum)
        Sin_p1 = T1 / S1
        Cos_p1 = Sum / S1
        Rn = m_arMajor[type] / sqrt(1.0 - m_Es[type] * Sin_p1 * Sin_p1)
        if (Cos_p1 >= COS_67P5) {
            Height = W / Cos_p1 - Rn
        }
        else if (Cos_p1 <= -COS_67P5) {
            Height = W / -Cos_p1 - Rn
        }
        else {
            Height = Z / Sin_p1 + Rn * (m_Es[type] - 1.0)
        }
        if (At_Pole == false) {
            Latitude = atan(Sin_p1 / Cos_p1)
        }

        p.x = Longitude
        p.y = Latitude
        p.z = Height
        return
    } // geocentric_to_geodetic()



    /****************************************************************/
    // geocentic_to_wgs84(defn, p )
   //  defn = coordinate system definition,
    //  p = point to transform in geocentric coordinates (x,y,z)
    private static func geocentric_to_wgs84(_ p : GeoTransPoint) {

      //if( defn.datum_type == PJD_3PARAM )
      //{
        // if( x[io] == HUGE_VAL )
        //    continue
        p.x += datum_params[0]
        p.y += datum_params[1]
        p.z += datum_params[2]
      //}
    } // geocentric_to_wgs84

    /****************************************************************/
    // geocentic_from_wgs84()
    //  coordinate system definition,
    //  point to transform in geocentric coordinates (x,y,z)
    private static func geocentric_from_wgs84(_ p : GeoTransPoint) {

      //if( defn.datum_type == PJD_3PARAM )
      //{
        //if( x[io] == HUGE_VAL )
        //    continue
        p.x -= datum_params[0]
        p.y -= datum_params[1]
        p.z -= datum_params[2]

      //}
    } //geocentric_from_wgs84()
}

