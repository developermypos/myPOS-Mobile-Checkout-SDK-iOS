//
//  AppDelegate.swift
//  Mobile Payment Test
//
//  Created by Valio Cholakov on 12/15/16.
//  Copyright © 2016 Intercard Finance AD. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        MPCheckout.initialize(in: .EUR,
                              withConfigurationKey: "eyJzaWQiOiIwMDAwMDAwMDAwMDAwMTAiLCJjbiI6IjYxOTM4MTY2NjEwIiwicGsiOiItLS0tLUJFR0lOIFJTQSBQUklWQVRFIEtFWS0tLS0tXG5NSUlDWEFJQkFBS0JnUUNmMFRkY1R1cGhiN1grWndla3QxWEtFV1pEY3pTR2VjZm82dlFmcXZyYWY1VlB6Y25KXG4yTWM1SjcySEJtMHU5OEVKSGFuK25sZTJXT1pNVkdJdFRhLzJrMUZSV3didDdpUTVkekRoNVBFZVpBU2cyVVdlXG5ob1I4TDhNcE5CcUg2aDdaSVR3VlRmUlM0THNCdmxFZlQ3UHpobTVZSktmTStDZHpETStMOVdWRUd3SURBUUFCXG5Bb0dBWWZLeHdVdEVicTh1bFZyRDNubldoRitoazFrNktlamRVcTBkTFlOMjl3OFdqYkNNS2I5SWFva21xV2lRXG41aVpHRXJZeGg3RzRCRFA4QVcvK005SFhNNG9xbTVTRWtheGhiVGxna3MrRTFzOWRUcGRGUXZMNzZUdm9kcVN5XG5sMkUyQmdoVmdMTGdrZGhSbjlidWFGell0YTk1SktmZ3lLR29uTnhzUUEzOVB3RUNRUURLYkcwS3A2S0VrTmdCXG5zckNxM0N4Mm9kNU9maVBERzhnM1JZWkt4L085ZE15NUNNMTYwRHd1c1ZKcHV5d2JwUmhjV3IzZ2t6MFFnUk1kXG5JUlZ3eXhOYkFrRUF5aDNzaXBtY2dON1NEOHhCRy9NdEJZUHFXUDF2eGhTVllQZkp6dVBVM2dTNU1SSnpRSEJ6XG5zVkNMaFRCWTdoSFNvcWlxbHFXWWFzaTgxSnpCRXdFdVFRSkJBS3c5cUdjWmp5TUg4SlU1VERTR2xscjNqeWJ4XG5GRk1QajhUZ0pzMzQ2QUI4b3pxTEwvVGh2V1BweEh0dEpiSDhRQWROdXlXZGc2ZElmVkFhOTVoN1krTUNRRVpnXG5qUkRsMUJ6N2VXR08yYzBGcTlPVHozSVZMV3BubUd3ZlcrSHlheGl6eEZoVitGT2oxR1VWaXI5aHlsVjdWMERVXG5Raklhanl2L29lRFdoRlE5d1FFQ1FDeWRoSjZOYU5RT0NaaCs2UVRySDNUQzVNZUJBMVllaXBvZTcrQmhzTE5yXG5jRkc4czlzVHhSbmx0Y1psMWRYYUJTZW12cE52Qml6bjBLemk4RzNaQWdjPVxuLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS1cbiIsInBjIjoiLS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tXG5NSUlCc1RDQ0FSb0NDUUNDUGpOdHRHTlFXREFOQmdrcWhraUc5dzBCQVFzRkFEQWRNUXN3Q1FZRFZRUUdFd0pDXG5SekVPTUF3R0ExVUVDZ3dGYlhsUVQxTXdIaGNOTVRneE1ERXlNRGN3T1RFeldoY05Namd4TURBNU1EY3dPVEV6XG5XakFkTVFzd0NRWURWUVFHRXdKQ1J6RU9NQXdHQTFVRUNnd0ZiWGxRVDFNd2daOHdEUVlKS29aSWh2Y05BUUVCXG5CUUFEZ1kwQU1JR0pBb0dCQU1MK1ZUbWlZNHlDaG9PVE1aVFhBSUcvbWsreGYvOW1qd0h4V3p4dEJKYk5uY05LXG4wT0xJMFZYWUtXMkdnVmtsR0hIUWp2ZXcxaFRGa0VHam5DSjdmNUNEbmJneGV2dHlBU0RHc3Q5MmE2eGNBZWRFXG5hZFAwbkZYaFV6K2NZWUlnSWNnZkRjWDNaV2VORUY1a3NjcXk1MmtwRDJPN25GTkNWKzg1dlM0ZHVKQk5BZ01CXG5BQUV3RFFZSktvWklodmNOQVFFTEJRQURnWUVBQ2oweGIrdE5ZRVJKa0wrcCt6RGNCc0JLNFJ2a25QbHBrK1lQXG5lcGh1bkcyZEJHT21nL1dLZ29EMVBMV0QyYkVmR2dKeFlCSWc5cjF3TFlwREMxdHhoeFYrMk9CUVM4NktVTGgwXG5ORWNyMHFFWTA1bUk0RmxFK0QvQnBULytXRnlLa1p1ZzkyckswRmx6NzFYeS85bUJYYlFmbStZSzZsOXJvUllkXG5KNHNIZVFjPVxuLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLVxuIiwiaWR4IjoiMSJ9",
                              isSandbox: true)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

