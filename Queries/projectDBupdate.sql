-- The Update queries in the field updates the database.
-- The changes can be monitored through the queries given in the comments


/*
select * from F23_S001_T6_RIDEDETAILS where couponcode is null and customerid in (
select customerid from f23_s001_t6_student)
*/

update F23_S001_T6_RIDEDETAILS set CouponCode = 'CAB20' where rideid=1012;


/*
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
*/


update F23_S001_T6_MonthlyTripRecord set milesdriven = 12500.4 where driverid = 3;

