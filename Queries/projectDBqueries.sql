-- Query 1: Show the users of the uber for each age group .

SELECT
    FLOOR(MONTHS_BETWEEN(CURRENT_DATE, F23_S001_T6_Customer.DOB) / 12) AS AgeGroup,
    COUNT(F23_S001_T6_Customer.DOB) AS Number_of_Customers
FROM
    F23_S001_T6_Customer
JOIN
    F23_S001_T6_RideDetails ON F23_S001_T6_Customer.CustomerID = F23_S001_T6_RideDetails.CustomerID
GROUP BY
    FLOOR(MONTHS_BETWEEN(CURRENT_DATE, F23_S001_T6_Customer.DOB) / 12)
ORDER BY
    AgeGroup;


--Queries 2: This query retrieves the total fare obtained for each combination of year, month, and driver, including the grand total:
SELECT
    MTR.Year,
    MTR.Month,
    D.Name AS DriverName,
    SUM(MTR.TotalFareObtained) AS TotalFareObtained
FROM
    F23_S001_T6_MonthlyTripRecord MTR
    JOIN F23_S001_T6_Driver D ON MTR.DriverID = D.DriverID
GROUP BY
    ROLLUP (MTR.Year, MTR.Month, D.Name)
ORDER BY
    MTR.Year DESC NULLS LAST,
    MTR.Month DESC NULLS LAST,
    D.Name DESC NULLS LAST;
    

--  Query 3: Calculate the percentage of student customers who use a coupon for their rides

SELECT
    COUNT(DISTINCT sc.CustomerID) AS TotalStudentCustomers,
    COUNT(DISTINCT CASE WHEN rd.CouponCode IS NOT NULL THEN sc.CustomerID END) AS StudentsWithCoupon,
    (COUNT(DISTINCT CASE WHEN rd.CouponCode IS NOT NULL THEN sc.CustomerID END) * 100.0 / NULLIF(COUNT(DISTINCT sc.CustomerID), 0)) AS PercentageWithCoupon
FROM
    F23_S001_T6_Student sc
JOIN
    F23_S001_T6_Customer c ON sc.CustomerID = c.CustomerID
LEFT JOIN
    F23_S001_T6_RideDetails rd ON sc.CustomerID = rd.CustomerID
LEFT JOIN
    F23_S001_T6_CouponDetails cd ON rd.CouponCode = cd.CouponCode;


--QUERY 4:  find the location with the highest total fare generated, and you want to include information about the driver associated with each ride

SELECT
    R.Source,
    SUM(R.Fare) AS Total_Fare_Generated,
    D.DriverID,
    D.Name AS DriverName
FROM
    F23_S001_T6_RideDetails R
JOIN
    F23_S001_T6_Driver D ON R.DriverID = D.DriverID
GROUP BY
    R.Source, D.DriverID, D.Name
ORDER BY
    Total_Fare_Generated DESC
FETCH FIRST 1 ROW ONLY;

-- Query 5: Find the driver who drives the least distance and retrieve driver's age and car's manufacturing year.
SELECT
    F23_S001_T6_Driver.DriverID,
    F23_S001_T6_Driver.Name AS DriverName,
    FLOOR(MONTHS_BETWEEN(CURRENT_DATE, F23_S001_T6_Driver.DOB) / 12) AS DriverAge,
    F23_S001_T6_Vehicle.YearOfManufacture AS CarManufacturingYear,
    MIN(F23_S001_T6_MonthlyTripRecord.MilesDriven) AS MinDistanceDriven
FROM
    F23_S001_T6_Driver
JOIN
    F23_S001_T6_Vehicle ON F23_S001_T6_Driver.DriverID = F23_S001_T6_Vehicle.DriverID
JOIN
    F23_S001_T6_MonthlyTripRecord ON F23_S001_T6_Driver.DriverID = F23_S001_T6_MonthlyTripRecord.DriverID
GROUP BY
    F23_S001_T6_Driver.DriverID, F23_S001_T6_Driver.Name, F23_S001_T6_Driver.DOB, F23_S001_T6_Vehicle.YearOfManufacture
ORDER BY
    MinDistanceDriven ASC
FETCH FIRST 1 ROW ONLY;


-- QUERY 6: Find customers name address and emailID , who have used all available coupon codes at least once.

SELECT DISTINCT
    C.Name,
    C.City , C.Street , C.State , C.PinCode,
    NVL(S.UniversityEmailID, NS.PersonalEmailID) AS EmailID,
    CP.PhoneNumber
FROM
    F23_S001_T6_Customer C
JOIN
    F23_S001_T6_RideDetails RD ON C.CustomerID = RD.CustomerID
LEFT JOIN
    F23_S001_T6_Student S ON C.CustomerID = S.CustomerID
LEFT JOIN
    F23_S001_T6_NonStudent NS ON C.CustomerID = NS.CustomerID
LEFT JOIN
    F23_S001_T6_CustomerPhoneNumber CP ON C.CustomerID = CP.CustomerID
WHERE
    NOT EXISTS (
        SELECT CD.CouponCode
        FROM F23_S001_T6_CouponDetails CD
        MINUS
        SELECT RD.CouponCode
        FROM F23_S001_T6_RideDetails RD
        WHERE RD.CustomerID = C.CustomerID
    );




--Query 7: retrieves the driver's name, total fare obtained, average rating, rank based on average rating.

SELECT
    DISTINCT(DriverID),
    DriverName,
    TotalFareObtained,
    AvgRating,
    RANK() OVER (ORDER BY AvgRating DESC) AS RankByAverageRating,
    VehicleType
FROM (
    SELECT
        D.DriverID,
        D.Name AS DriverName,
        SUM(RD.Fare) OVER (PARTITION BY RD.DriverID) AS TotalFareObtained,
        AVG(RD.Rating) OVER (PARTITION BY RD.DriverID) AS AvgRating,
        MAX(V.VehicleType) OVER (PARTITION BY D.DriverID) AS VehicleType,
        MAX(MTR.MilesDriven) OVER (PARTITION BY D.DriverID) AS MilesDriven
    FROM
        F23_S001_T6_Driver D
    JOIN
        F23_S001_T6_RideDetails RD ON D.DriverID = RD.DriverID
    LEFT JOIN
        F23_S001_T6_Vehicle V ON D.DriverID = V.DriverID
    LEFT JOIN
        F23_S001_T6_MonthlyTripRecord MTR ON D.DriverID = MTR.DriverID AND MTR.Year = 2023
) DriverDetails
ORDER BY
    RankByAverageRating;


