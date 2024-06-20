-- DDL

-- Driver table 
CREATE TABLE F23_S001_T6_Driver (
    DriverID INT PRIMARY KEY,
    DOB DATE,
    PlaceOfBirth VARCHAR(255),
    Name VARCHAR(255),
    Gender CHAR(1),
    City VARCHAR(255),
    Street VARCHAR(255),
    State VARCHAR(255),
    PinCode VARCHAR(10)
);

-- Customer table 
CREATE TABLE F23_S001_T6_Customer (
    CustomerID INT PRIMARY KEY,
    DOB DATE,
    Name VARCHAR(255),
    Gender CHAR(1),
    City VARCHAR(255),
    Street VARCHAR(255),
    State VARCHAR(255),
    PinCode VARCHAR(10)
);

-- CouponDetails table 
CREATE TABLE F23_S001_T6_CouponDetails (
    CouponCode VARCHAR(255) PRIMARY KEY,
    DiscountPercentage DECIMAL(5, 2)
);

-- RideDetails table 
CREATE TABLE F23_S001_T6_RideDetails (
    RideID INT PRIMARY KEY,
    DriverID INT,
    CouponCode VARCHAR(255),
    CustomerID INT,
    Fare DECIMAL(10, 2),
    Source VARCHAR(255),
    RideDate DATE, -- Changed column name from "Date" to "RideDate"
    Rating INT,
    TypeOfVehicle VARCHAR(255),
    FOREIGN KEY (DriverID) REFERENCES F23_S001_T6_Driver(DriverID),
    FOREIGN KEY (CustomerID) REFERENCES F23_S001_T6_Customer(CustomerID),
    FOREIGN KEY (CouponCode) REFERENCES F23_S001_T6_CouponDetails(CouponCode)
);


-- CustomerPhoneNumber table
CREATE TABLE F23_S001_T6_CustomerPhoneNumber (
    CustomerID INT,
    PhoneNumber VARCHAR(15),
    PRIMARY KEY (CustomerID, PhoneNumber),
    FOREIGN KEY (CustomerID) REFERENCES F23_S001_T6_Customer(CustomerID)
);

-- Student table 
CREATE TABLE F23_S001_T6_Student (
    CustomerID INT,
    UniversityEmailID VARCHAR(255),
    PRIMARY KEY (CustomerID, UniversityEmailID),
    FOREIGN KEY (CustomerID) REFERENCES F23_S001_T6_Customer(CustomerID)
);

-- Non Student Table
CREATE TABLE F23_S001_T6_NonStudent (
    CustomerID INT,
    PersonalEmailID VARCHAR(255),
    PRIMARY KEY (CustomerID, PersonalEmailID),
    FOREIGN KEY (CustomerID) REFERENCES F23_S001_T6_Customer(CustomerID)
);


-- DriverIdentification table (DONE)
CREATE TABLE F23_S001_T6_DriverIdentification (
    DrivingLicenseNumber VARCHAR(20) PRIMARY KEY,
    DriverID INT,
    SSN VARCHAR(15),
    PassportNumber VARCHAR(20),
    FOREIGN KEY (DriverID) REFERENCES F23_S001_T6_Driver(DriverID)
);

-- Vehicle table (DONE)
CREATE TABLE F23_S001_T6_Vehicle (
    VehicleNumber VARCHAR(20) PRIMARY KEY,
    DriverID INT,
    VehicleType VARCHAR(255),
    VehicleManufacturers VARCHAR(255),
    MainName VARCHAR(255),
    ModelName VARCHAR(255),
    YearOfManufacture INT,
    FOREIGN KEY (DriverID) REFERENCES F23_S001_T6_Driver(DriverID)
);

-- PaymentDetails table (DONE)
CREATE TABLE F23_S001_T6_PaymentDetails (
    PaymentID INT PRIMARY KEY,
    PaymentMethod VARCHAR(255),
    Tips DECIMAL(10, 2),
    RideID INT,
    FOREIGN KEY (RideID) REFERENCES F23_S001_T6_RideDetails(RideID)
);

-- MonthlyTripRecord table (DONE)
CREATE TABLE F23_S001_T6_MonthlyTripRecord (
    Year INT,
    Month VARCHAR(255), 
    DriverID INT,
    MilesDriven DECIMAL(10, 2),
    TripsCompleted INT,
    TripsReceived INT,
    TotalFareObtained DECIMAL(10, 2),
    PRIMARY KEY (Year, Month , DriverID),
    FOREIGN KEY (DriverID) REFERENCES F23_S001_T6_Driver(DriverID)
);